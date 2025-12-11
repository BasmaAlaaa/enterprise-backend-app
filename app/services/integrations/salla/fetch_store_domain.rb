module Integrations
  module Salla
    class FetchStoreDomain
      include Interactor

      delegate :access_token, to: :context

      def call
        url = 'https://api.salla.dev/admin/v2/store/info'
        headers = {
          'Authorization' => "Bearer #{access_token}",
          'Content-Type' => 'application/json'
        }

        response = HTTParty.get(url, headers: headers)

        if response.success?
          context.domain = response.dig("data", "domain")
        else
          context.fail!(message: "Failed to fetch store domain: #{response.parsed_response}")
        end
      end
    end
  end
end
