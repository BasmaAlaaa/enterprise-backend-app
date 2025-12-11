module Integrations
  module Salla
    class UpdateCollection
      include Interactor
      delegate :user, :salla_id, :category_id, :category_details, :fail!, to: :context

      def call
        handler =SallaHandler.new(user, salla_id)
        response = handler.update_collection(category_id, category_details)
        if response
          context.integration = handler.get_integration
          context.category = response
        else
          fail!(errors: response.body)
        end
      end
    end
  end
end
