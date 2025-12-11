module Integrations
  module Salla
  class UpdateProductImage
      include Interactor
      delegate :user, :salla_id, :image_id, :image_details, :fail!, to: :context

      def call
        handler = SallaHandler.new(user, salla_id)
        response = handler.update_product_image(image_id,image_details)

        if response
          context.product = response
        else
          fail!(errors: response.body)
        end
      end
    end
  end
end