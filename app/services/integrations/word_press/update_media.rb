
module Integrations
  module WordPress
    class UpdateMedia
      include Interactor

      delegate :user,:wordpress_id ,:params, :fail!, to: :context

      def call
        integration = user.integrations.find(wordpress_id)
        handler = WordPressHandler.new(integration)
        response = handler.update_media(params)

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