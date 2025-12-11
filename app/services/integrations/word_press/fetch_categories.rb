
module Integrations
    module WordPress
      class FetchCategories
        include Interactor
  
        delegate :user,:wordpress_id, :per_page, :page, :search, :fail!, to: :context

        def call
          integration = user.integrations.find(wordpress_id)
          handler = WordPressHandler.new(integration)
          response = handler.fetch_categories(per_page, page, search)
          if response
            context.integration = integration
            context.categories = response['collections']
            context.pagination = response['pagination']
          else
            fail!(errors: response.body)
          end
        end
      end
    end
  end