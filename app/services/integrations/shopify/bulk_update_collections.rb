module Integrations
  module Shopify
    class BulkUpdateCollections
      include Interactor

      delegate :user, :params, :collection_params, :fail!, to: :context

      def call
        integration = user.integrations.find(params[:shopify_id])
        fail!(error: "No Shopify store connected!") unless integration

        session = ShopifyAPI::Auth::Session.new(
          shop: integration.domain,
          access_token: integration.token,
        )            
        ShopifyAPI::Context.activate_session(session)

        failed_collections = []
        collection_params[:attributes].each do |collection|
          mutation = <<~GQL
            mutation collectionUpdate($input: CollectionInput!) {
              collectionUpdate(input: $input) {
                collection {
                  id
                }
                userErrors {
                  field
                  message
                }
              }
            }
          GQL

          client = ShopifyAPI::Clients::Graphql::Admin.new(session: session)
          response = client.query(query: mutation, variables: {input: collection.to_h}).body
          failed_collections << {error: response["errors"], id: collection[:id]} if response["errors"]
        end
      end
    end
  end
end
