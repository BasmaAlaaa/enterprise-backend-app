module Integrations
  module Shopify
    class UpdateProduct
      include Interactor

      delegate :user, :params, :product_params, :fail!, to: :context

      def call
        integration = user.integrations.find_by(id: params[:shopify_id])
        fail!(errors: "No Shopify store connected!") unless integration

        session = ShopifyAPI::Auth::Session.new(
          shop: integration.domain,
          access_token: integration.token,
        )            
        ShopifyAPI::Context.activate_session(session)

        client = ShopifyAPI::Clients::Rest::Admin.new(session: session)
        result = client.put(path: "products/#{params[:id]}.json", body: {product: product_params.to_h})

        unless result.ok?
          context.fail!(error: "Failed to update product: #{result.errors.join(', ')}")
        end
      end
    end
  end
end
