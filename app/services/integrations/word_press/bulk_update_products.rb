module Integrations
  module WordPress
    class BulkUpdateProducts
      include Interactor

      delegate :user, :wordpress_id, :params, :fail!, to: :context

      def call
        integration = user.integrations.find(wordpress_id)
        handler=Integrations::WordPress::WordPressHandler.new(integration)
        response = handler.bulk_update_products(params)

        if response
          context.integration = integration
          context.products = response
        else
          fail!(errors: response.body)
        end
      end
    end
  end
end
