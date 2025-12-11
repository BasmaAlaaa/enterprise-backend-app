module Integrations
  module Shopify
    class FetchArticles
      include Interactor

      delegate :user, :params, :fail!, to: :context

      def call
        integration = user.integrations.find(params[:shopify_id])
        fail!(errors: "No Shopify store connected!") unless integration

        query_params = {
          limit: 10,
          fields: "id,title,url,handle,blog_id,updated_at,image"
        }
        query_params[:handle] = params[:search] if params[:search].present?
        query_params[:page_info] = params[:cursor] if params[:cursor].present?

        session = ShopifyAPI::Auth::Session.new(
          shop: integration.domain,
          access_token: integration.token,
        )            
        ShopifyAPI::Context.activate_session(session)

        client = ShopifyAPI::Clients::Rest::Admin.new(session: session)
        results = client.get(path: "blogs/#{params[:blog_id]}/articles", query: query_params)

        articles = results.body['articles']
        context.articles = articles
        context.pagination = {
          "hasNextPage": !results.next_page_info.nil? ,
          "hasPreviousPage": !results.prev_page_info.nil?,
          "next": results.next_page_info,
          "current":  params[:cursor], 
          "totalPages": nil
        }
      end
    end
  end
end
