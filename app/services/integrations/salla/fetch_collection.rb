module Integrations
  module Salla
    class FetchCollection
      include Interactor
      delegate :user, :salla_id, :category_id, :fail!, to: :context

      def call
        handler=SallaHandler.new(user, salla_id)
        response = handler.fetch_collection(category_id)
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
