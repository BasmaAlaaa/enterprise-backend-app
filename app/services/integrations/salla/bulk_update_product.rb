module Integrations
  module Salla
    class BulkUpdateProduct
      include Interactor

      delegate :user, :salla_id, :products, to: :context

      def call
        handler = SallaHandler.new(user, salla_id)
        context.failed_products = []
        context.updated_products = []

        products.each do |product|
          response = handler.update_product(product[:product_id], product[:product_details])

          if response
            context.updated_products << response
          else
            context.failed_products << { product_id: product[:product_id], error: response }
          end
        end

        if context.failed_products.any?
          context.fail!(errors: context.failed_products)
        end
      end
    end
  end
end
