module Integrations
    module Shopify
      class AccessToken
        include Interactor
    
        delegate  :code, :params, :fail!, to: :context
        def call
            uri = "https://#{params[:shop]}/admin/oauth/access_token?client_id=#{ENV["SHOPIFY_API_KEY"]}&client_secret=#{ENV["SHOPIFY_API_SECRET"]}&code=#{params[:code]}"
            response = HTTParty.post(uri)
            fail!(errors: response) unless response.success?
            integration = Integration.find_or_create_by(integration_type:'shopify', domain: params[:shop])
            integration.update(token: response["access_token"])
            context.integration = integration
            context.response = response
        end
      end
    end
  end