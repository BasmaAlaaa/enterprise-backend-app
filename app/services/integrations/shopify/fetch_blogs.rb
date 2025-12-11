module Integrations
  module Shopify
    class FetchBlogs
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
        client = ShopifyAPI::Clients::Rest::Admin.new(session: session)
        response = client.get(path: "blogs", query: { limit: 10, page_info: params[:cursor] })

        context.articles = response.body['blogs']
        context.has_next_page = response.next_page_info

      end
    end
  end
end