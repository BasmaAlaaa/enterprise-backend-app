module Integrations
  module Shopify
    class BulkUpdateMedia
      include Interactor

      delegate :user, :params, :media_params, :fail!, to: :context

      def call
        integration = user.integrations.find(params[:shopify_id])
        fail!(error: "No Shopify store connected!") unless integration

        session = ShopifyAPI::Auth::Session.new(
          shop: integration.domain,
          access_token: integration.token,
        )
        ShopifyAPI::Context.activate_session(session)

        mutation = <<~QUERY
        mutation fileUpdate($files: [FileUpdateInput!]!) {
          fileUpdate(files: $files) {
            files {
              id
            }
            userErrors {
              field
              message
            }
          }
        }
        QUERY

        client = ShopifyAPI::Clients::Graphql::Admin.new(session: session)
        response = client.query(query: mutation, variables: media_params.to_h) 

        if response.body["errors"]
          fail!(error: response.body["errors"])
        else
          context.response = response.body
        end
      end
    end
  end
end
