module Integrations
  module WordPress
    class FetchMedia
      include Interactor

      delegate :user,:wordpress_id,:per_page, :page, :fail!, to: :context

      def call
        integration = user.integrations.find(wordpress_id)
        handler = WordPressHandler.new(integration)
        response = handler.fetch_media(per_page, page)
        if response
          context.integration = integration
          context.media = response['media']
          context.pagination = response['pagination']
        else
          fail!(errors: response.body)
        end
      end
    end
  end
end