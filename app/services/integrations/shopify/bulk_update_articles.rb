module Integrations
  module Shopify
    class BulkUpdateArticles
      include Interactor

      delegate :user, :params, :bulk_article_params, :fail!, to: :context

      def call
        integration = user.integrations.find(params[:shopify_id])
        fail!(errors: "No Shopify store connected!") unless integration

        session = ShopifyAPI::Auth::Session.new(
          shop: integration.domain,
          access_token: integration.token,
        )            
        ShopifyAPI::Context.activate_session(session)

        failed_articles = []
        bulk_article_params[:attributes].each do |article|
          client = ShopifyAPI::Clients::Rest::Admin.new(session: session)
          result = client.put(path: "blogs/#{article[:blog_id]}/articles/#{article[:id]}.json", body: {article: article})
          Rails.logger.info({result: result, article: article })

          failed_articles << article[:title] unless result.ok?
        end

        context.failed_articles = failed_articles
      end
    end
  end
end
