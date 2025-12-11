module Integrations
  module Shopify
    class FetchCollections
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

        search = params[:search].present? ? "*#{params[:search]}*" : "*"
        cursor = params[:cursor].present? ? "after: \"#{params[:cursor]}\"," : ""
        query = <<~QUERY
          {
            collections(first: 10, #{cursor} query: "title:#{search}") {
              edges {
                cursor
                node {
                  id
                  title
                  handle
                  description
                  updatedAt
                  seo {
                    description
                    title
                  }
                  image {
                    url
                    altText
                    id
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

        client = ShopifyAPI::Clients::Graphql::Admin.new(session: session)
        response = client.query(query: query)
        collections_data = response.body.dig("data", "collections")
        context.collections = collections_data["edges"]
        page_info = collections_data["pageInfo"]
        context.pagination = {
        "hasNextPage": page_info["hasNextPage"],
        "hasPreviousPage": page_info["hasPreviousPage"],
        "next": page_info["endCursor"],  
        "current":  page_info["startCursor"],  
        "totalPages": nil  
        }

      end
    end
  end
end
