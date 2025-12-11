module Integrations
  module Shopify
    class UpdateArticle
      include Interactor

      delegate :user, :params, :article_params, :fail!, to: :context

      def call
        integration = user.integrations.find(params[:shopify_id])
        fail!(errors: "No Shopify store connected!") unless integration

        session = ShopifyAPI::Auth::Session.new(
          shop: integration.domain,
          access_token: integration.token,
        )            
        ShopifyAPI::Context.activate_session(session)

        client = ShopifyAPI::Clients::Rest::Admin.new(session: session)
        result = client.put(path: "blogs/#{article_params[:blog_id]}/articles/#{params[:id]}.json", body: {article: article_params})

        unless result.ok?
          context.fail!(error: "Failed to update article: #{result.body['errors']}")
        end
      end
    end
  end
end
