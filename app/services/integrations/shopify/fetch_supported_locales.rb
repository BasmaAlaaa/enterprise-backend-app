module Integrations
  module Shopify
    class FetchSupportedLocales
      include Interactor

      delegate :user, :params, :fail!, to: :context

      def call
        integration = user.integrations.find(params[:shopify_id])
        fail!(errors: "No Shopify store connected!") unless integration

        session = ShopifyAPI::Auth::Session.new(
          shop: integration.domain,
          access_token: integration.token,
        )            
        ShopifyAPI::Context.activate_session(session)

        query = <<~GQL
          query {
            shopLocales {
              locale
              primary
              published
            }
          }
        GQL

        client = ShopifyAPI::Clients::Graphql::Admin.new(session: session)
        response = client.query(query: query)
        locales = response.body["data"]["shopLocales"].map do |locale|
          {
            locale: locale["locale"],
            primary: locale["primary"],
          }
        end

        context.locales = locales
      rescue StandardError => e
        context.fail!(errors: e.message)
      end
    end
  end
end