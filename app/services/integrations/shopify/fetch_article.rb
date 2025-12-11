module Integrations
  module Shopify
    class FetchArticle
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

        client = ShopifyAPI::Clients::Rest::Admin.new(session: session)
        article_results = client.get(path: "blogs/#{params[:blog_id]}/articles/#{params[:id]}", query: {
          fields: "id,metafields,title,image,body_html,blog_id,handle,summary_html,published_at,blog_id,updated_at,seo"
        })

        unless article_results.ok?
          context.fail!(error: "Failed to fetch article")
          return
        end

        metafields_results = client.get(path: "articles/#{params[:id]}/metafields", query: {})
        unless metafields_results.ok?
          context.fail!(error: "Failed to fetch article metafields")
          return
        end

        article = article_results.body['article']
        article['metafields'] = metafields_results.body['metafields']

        context.article = article
      end
    end
  end
end
