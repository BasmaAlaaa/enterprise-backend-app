
module Integrations
      class Install
        include Interactor
  
        delegate :url, :redirect_uri, :api_key, :auth_token, :client_id, :scope, :other_params, :fail!, to: :context
  
        def call

          auth_url = "#{url}?client_id=#{api_key}&response_type=code&redirect_uri=#{redirect_uri}&scope=#{scope}&state=#{auth_token}:#{client_id}" + other_params
          context.url =  auth_url
        end
      end
  end