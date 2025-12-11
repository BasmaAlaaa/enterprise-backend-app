module Integrations
  module Salla
    class CreateProduct
      include Interactor
      delegate :user, :salla_id, :product_details, :fail!, to: :context

      def call
        handler=SallaHandler.new(user, salla_id)
        response=handler.create_product(product_details)
        if response
          context.integration =  handler.get_integration
          context.response = response
        else
          fail!(errors: response.body)
        end
      end
    end
  end
end
