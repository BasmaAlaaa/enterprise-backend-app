module Integrations
  module Shopify
    class FetchCollection
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
            collection(id: "gid://shopify/Collection/#{params[:id]}") {
              id
              title
              handle
              updatedAt
              image {
                id
                url
                altText
              }
            }
          }
        QUERY

        client = ShopifyAPI::Clients::Graphql::Admin.new(session: session)
        response = client.query(query: query)
        collection_data = response.body.dig("data", "collection")
        context.collection = collection_data
      end
    end
  end
end
