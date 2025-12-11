

module Integrations
    module WordPress
      class AccessToken
        include Interactor
    
        delegate :params, :fail!, to: :context
        def call
        integration = Integration.find_or_initialize_by(integration_type: 'wordpress', domain: params[:domain])
        handler = Integrations::WordPress::WordPressHandler.new(integration)
        response=handler.install(params[:domain], params[:token])
        context.status = response["status"]
        context.integration = integration
        context.response = response
        end
      end
    end
  end