module Integrations
  module Salla
    class CustomAccessToken
      include Interactor

      delegate :code, :fail!, to: :context

      def call
        body = {
          "client_id": ENV.fetch('SALLA_CLIENT_ID', 'de4a2559-fbb8-4ccf-972f-cede72d74164'),
          "client_secret": ENV.fetch('SALLA_CLIENT_SECRET', '73e8c031c6ea3b24b1ee4cfd0ea921cc'),
          "grant_type": "authorization_code",
          "code": code,
          "scope": "offline_access",
          "redirect_uri": ENV["SALLA_REDIRECT_URI"]
          }

        response = HTTParty.post('https://accounts.salla.sa/oauth2/token',:body => body.as_json)
        shop = HTTParty.get("https://api.salla.dev/admin/v2/store/info", headers: { 'Authorization' => "Bearer #{response["access_token"]}" ,  'Content-Type' => 'application/json'})
        fail!(errors: response) unless response.success?
        integration = Integration.find_or_create_by(integration_type:'salla', domain: shop["data"]["domain"])
        integration.update(token: response["access_token"], refresh_token: response["refresh_token"])
        context.integration = integration
        context.response = response
      end
    end
  end
end