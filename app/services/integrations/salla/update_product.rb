module Integrations
  module Salla
    class UpdateProduct
      include Interactor
      delegate :user, :salla_id, :product_id, :product_details, :fail!, to: :context

      def call
        handler = SallaHandler.new(user, salla_id)
        response = handler.update_product(product_id, product_details)
        if response
          context.product = response
        else
          fail!(errors: response.body)
        end
      end
    end
  end
end
