
module Integrations
  module WordPress
    class UpdateCategory
      include Interactor

      delegate :user,:wordpress_id ,:params, :fail!, to: :context

      def call
          integration = user.integrations.find(wordpress_id)
          handler = WordPressHandler.new(integration)
          response = handler.update_category(params)

          if response
            context.integration = integration
            context.category = response
          else
            fail!(errors: response.body)
          end
      end
    end
  end
end