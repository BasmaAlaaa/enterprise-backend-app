
module Integrations
  module WordPress
    class ShowProduct
      include Interactor

      delegate :user,:wordpress_id, :id, :fail!, to: :context

      def call
        integration = user.integrations.find(wordpress_id)
        handler=WordPressHandler.new(integration)
        response=handler.show_product(id)

        if response
          context.integration = integration
          context.product = response
        else
          fail!(errors: response.body)
        end
      end
    end
  end
end