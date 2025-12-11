class Integrations::Shopify::Products::Index
  include Interactor

  delegate :user, :shopify_id, :product_ids, :fail!, to: :context

  def call
    edges = fetch_original_product_contents(product_ids)
    context.edges = edges
  end

  private

  def fetch_original_product_contents(product_ids)
    search = product_ids.map { |id| "id:#{id}" }.join(' OR ')
    query = <<~QUERY
      {
        products(first: 100, query: "#{search}") {
          edges {
            node {
              id
              title
              descriptionHtml
              handle
              seo {
                title
                description
              }
            }
          }
        }
      }
    QUERY
    integration = user.integrations.find(shopify_id)
    fail!(errors: "No Shopify store connected!") unless integration

    session = ShopifyAPI::Auth::Session.new(
      shop: integration.domain,
      access_token: integration.token,
    )
    ShopifyAPI::Context.activate_session(session)
    client = ShopifyAPI::Clients::Graphql::Admin.new(session: session)
    client.query(query: query).body["data"]["products"]["edges"]
  end
end
