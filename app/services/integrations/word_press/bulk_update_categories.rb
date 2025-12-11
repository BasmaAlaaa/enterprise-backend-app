module Integrations
  module WordPress
    class BulkUpdateCategories
      include Interactor

      delegate :user, :wordpress_id, :params, :fail!, to: :context

      def call
        integration = user.integrations.find(wordpress_id)
        handler=Integrations::WordPress::WordPressHandler.new(integration)
        response = handler.bulk_update_collections(params)

        if response
          context.integration = integration
          context.collections = response
        else
          fail!(errors: response.body)
        end
      end
    end
  end
end
