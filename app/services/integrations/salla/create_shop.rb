module Integrations
  module Salla
    class CreateShop
      include Interactor

      delegate :access_token, :refresh_token, :scopes, :email, :fail!, to: :context

      def call
        response = HTTParty.get(
          "https://api.salla.dev/admin/v2/store/info",
          headers: {
            "Authorization" => "Bearer #{access_token}",
            "Content-Type" => "application/json"
          }
        )

        fail!(message: response.parsed_response) unless response.success?

        data = response["data"]

        shop = Shop.find_or_initialize_by(provider: :salla,domain: data["domain"])

        shop_email = email || data["email"]

        shop.assign_attributes(name: data["name"], email: shop_email, access_token: access_token, refresh_token: refresh_token, access_scopes: scopes)

        shop.save!

        context.shop = shop
      end
    end
  end
end