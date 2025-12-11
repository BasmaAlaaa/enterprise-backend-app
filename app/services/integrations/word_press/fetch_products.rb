
module Integrations
    module WordPress
      class FetchProducts
        include Interactor
  
        delegate :user,:wordpress_id, :per_page, :page, :search, :fail!, to: :context

        def call
          integration = user.integrations.find(wordpress_id)
          handler=WordPressHandler.new(integration)
          response=handler.fetch_products(per_page, page, search)

          if response
            context.integration = integration
            context.products = response['products']
            context.pagination = response['pagination']
          else
            fail!(errors: response.body)
          end
        end
      end
    end
  end