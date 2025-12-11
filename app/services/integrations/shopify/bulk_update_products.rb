module Integrations
  module Shopify
    class BulkUpdateProducts
      include Interactor

      delegate :user, :params, :bulk_update_params, :fail!, to: :context

      def call
        integration = user.integrations.find_by(id: params[:shopify_id])
        fail!(errors: "No Shopify store connected!") unless integration

        session = ShopifyAPI::Auth::Session.new(
          shop: integration.domain,
          access_token: integration.token,
        )            
        ShopifyAPI::Context.activate_session(session)

        failed_products = []
        bulk_update_params[:attributes].each do |product|
          client = ShopifyAPI::Clients::Rest::Admin.new(session: session)
          result = client.put(path: "products/#{product[:id]}.json", body: {product: product.except(:id).to_h})

          unless result.ok?
            failed_products << product[:title] 
          end
        end

        if failed_products.any?
          context.fail!(failed_products: failed_products)
        end
      end
    end
  end
end
