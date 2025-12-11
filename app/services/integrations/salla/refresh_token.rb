module Integrations
  module Salla
    class RefreshToken
      include Interactor
      delegate :integration, :fail!, to: :context
      def call
        body = {
          "client_id":  ENV["SALLA_CLIENT_ID"],
          "client_secret":  ENV["SALLA_CLIENT_SECRET"],
          "grant_type": "refresh_token",
          "refresh_token": integration.refresh_token,
          "scope": "offline_access",
          "redirect_uri": ENV["SALLA_REDIRECT_URI"]
        }
  
        response = HTTParty.post('https://accounts.salla.sa/oauth2/token',:body => body.as_json)
        fail!(errors: response) unless response.success?
        
        integration.update(token: response["access_token"], refresh_token: response["refresh_token"])
        return response
      end
    end
  end
end