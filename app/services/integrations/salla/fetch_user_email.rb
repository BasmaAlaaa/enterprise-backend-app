module Integrations
  module Salla
    class FetchUserEmail
      include Interactor

      delegate :access_token, to: :context

      def call
        url = 'https://api.salla.dev/admin/v2/oauth2/user/info'
        headers = {
          'Authorization' => "Bearer #{access_token}",
          'Content-Type' => 'application/json'
        }

        response = HTTParty.get(url, headers: headers)

        if response.success?
          context.email = response.dig("data", "email")
          context.name = response.dig("data", "name")
        else
          context.fail!(message: "Failed to fetch user email: #{response.parsed_response}")
        end
      end
    end
  end
end
