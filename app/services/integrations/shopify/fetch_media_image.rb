module Integrations
  module Shopify
    class FetchMediaImage
      include Interactor

      delegate :user, :params, :fail!, to: :context

      def call
        integration = user.integrations.find(params[:shopify_id])
        fail!(error: "No Shopify store connected!") unless integration

        session = ShopifyAPI::Auth::Session.new(
          shop: integration.domain,
          access_token: integration.token,
        )
        ShopifyAPI::Context.activate_session(session)

        query = <<~QUERY
        {
          node(id: "gid://shopify/MediaImage/#{params[:id]}") {
            id
            ... on MediaImage {
              image {
                url
                altText
                id
              }
            }
          }
        }
        QUERY

        client = ShopifyAPI::Clients::Graphql::Admin.new(session: session)
        response = client.query(query: query)
        media_data = response.body.dig("data", "node")

        fail!(error: "Media not found") unless media_data

        context.media = media_data
      end
    end
  end
end
