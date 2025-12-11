module Integrations
  module WordPress
    class BulkUpdateMedia
      include Interactor

      delegate :user, :wordpress_id, :params, :fail!, to: :context

      def call
        integration = user.integrations.find(wordpress_id)
        handler=Integrations::WordPress::WordPressHandler.new(integration)
        response = handler.bulk_update_media(params)

        if response
          context.integration = integration
          context.media = response
        else
          fail!(errors: response.body)
        end
      end
    end
  end
end
