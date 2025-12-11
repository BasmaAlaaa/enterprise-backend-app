module Integrations
  module WordPress
    class ShowPost
      include Interactor

      delegate :user,:wordpress_id, :id, :search, :fail!, to: :context

      def call
        integration = user.integrations.find(wordpress_id)
        handler = WordPressHandler.new(integration)
        response = handler.show_post(id)
        if response
          context.integration = integration
          context.post = response
        else
          fail!(errors: response.body)
        end
      end
    end
  end
end