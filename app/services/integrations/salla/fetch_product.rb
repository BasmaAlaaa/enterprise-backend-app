module Integrations
  module Salla
    class FetchProduct
      include Interactor
      delegate :user, :salla_id, :product_id, :fail!, to: :context

      def call
        handler=SallaHandler.new(user, salla_id)
        response=handler.fetch_product(product_id)

        if response
          context.integration = handler.get_integration
          context.product = response
        else
          fail!(errors: response.body)
        end
      end
    end
  end
end
