module Integrations
    module Shopify
      class FetchProducts
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
                products(first: 10, #{cursor} query: "title:#{search}") {
                  edges {
                    cursor
                    node {
                      id
                      title
                      onlineStoreUrl
                      description
                      handle
                      status
                      onlineStorePreviewUrl
                      seo {
                        description
                        title
                      }
                      updatedAt
                      images(first: 250) {
                        edges {
                          node {
                            id
                            src
                            altText
                          }
                        }
                      }
                    }
                  }
                  pageInfo {
                    hasNextPage
                    hasPreviousPage
                    startCursor
                    endCursor
                  }
                }
              }
            QUERY
            
            response = client.query(query: query)
            context.products = response.body["data"]["products"]
            context.response = response
            page_info = context.products["pageInfo"]
            context.pagination = {
              "hasNextPage": page_info["hasNextPage"],
              "hasPreviousPage": page_info["hasPreviousPage"],
              "next": page_info["endCursor"], 
              "current": page_info["startCursor"] ,
              "totalPages": nil
            }
        end
      end
    end
  end