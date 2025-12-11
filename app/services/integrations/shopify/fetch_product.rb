module Integrations
  module Shopify
    class FetchProduct
      include Interactor

      delegate :user, :params, :fail!, to: :context

      def call
        integration = user.integrations.find(params[:shopify_id])
        fail!(errors: "No Shopify store connected!") unless integration

        session = ShopifyAPI::Auth::Session.new(
          shop: integration.domain,
          access_token: integration.token,
        )            
        ShopifyAPI::Context.activate_session(session)

        query = <<~GQL
          {
            product(id: "gid://shopify/Product/#{params[:id]}") {
              title
              id
              description
              onlineStoreUrl
              status
              handle
              seo {
                title
                description
              }
              images(first: 250) {
                edges {
                  node {
                    id
                    altText
                    src
                  }
                }
              }
            }
          }
        GQL

        client = ShopifyAPI::Clients::Graphql::Admin.new(session: session)
        response = client.query(query: query)
        product = response.body["data"]["product"]

        unless product
          context.fail!(error: "Product not found")
          return
        end

        context.product = product
      end
    end
  end
end
