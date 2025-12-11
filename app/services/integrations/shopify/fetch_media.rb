module Integrations
  module Shopify
    class FetchMedia
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

        search = params[:search].present? ? "#{params[:search]}" : "*"
        cursor = params[:cursor].present? ? "after: \"#{params[:cursor]}\"," : ""
        client = ShopifyAPI::Clients::Graphql::Admin.new(session: session)
        query = <<~QUERY
        {
          files(first: 10, #{cursor}) {
            edges {
              node {
                id
                ... on MediaImage {
                  id
                  image {
                    url
                    altText
                  }
                }
              }
            }
            pageInfo {
              hasNextPage
              hasPreviousPage
              endCursor
              startCursor
            }
          }
        }
        QUERY

        response = client.query(query: query)
        files_data = response.body.dig("data", "files")
        context.files = files_data["edges"]
        context.page_info = files_data["pageInfo"]
      end
    end
  end
end
