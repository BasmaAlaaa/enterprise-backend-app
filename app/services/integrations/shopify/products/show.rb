module Integrations::Shopify::Products  
  class Show
    include Interactor

    delegate :user, :params, :id, :fail!, to: :context

    def call
      integration = user.integrations.find(params[:shopify_id])
      fail!(errors: "No Shopify store connected!") unless integration

      session = ShopifyAPI::Auth::Session.new(
        shop: integration.domain,
        access_token: integration.token,
      )
      ShopifyAPI::Context.activate_session(session)

      query = <<~QUERY
        query {
          product(id: "#{id}") {
            title
            descriptionHtml
            handle
            seo {
              title
              description
            }
          }
        }
      QUERY

      client = ShopifyAPI::Clients::Graphql::Admin.new(session: session)
      response = client.query(query: query)
      result = response.body["data"]["product"]

      context.original_content = {
        title: result["title"],
        description_html: result["descriptionHtml"],
        handle: result["handle"],
        seo: {
          title: result.dig("seo", "title"),
          description: result.dig("seo", "description")
        }
      }
    rescue => e
      context.fail!(message: "Error fetching original product content: #{e.message}")
    end
  end
end
