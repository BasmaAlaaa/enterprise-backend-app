
module Integrations
  module WordPress
    class ShowMedia
      include Interactor

      delegate :user,:wordpress_id, :id, :fail!, to: :context

      def call
        integration = user.integrations.find(wordpress_id)
        handler=WordPressHandler.new(integration)
        response=handler.show_media(id)

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