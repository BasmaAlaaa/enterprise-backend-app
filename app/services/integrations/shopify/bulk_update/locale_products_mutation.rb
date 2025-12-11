module Integrations::Shopify::BulkUpdate
  class LocaleProductsMutation
    include Interactor

    delegate :prepared_data, :shopify_id, :user, :fail!, to: :context

    def call
      errors = []
      prepared_data.each do |item|
        result=perform_mutation(item)
        errors.concat(result["userErrors"]) if result["userErrors"].any?
      end
      context.fail!(errors: errors) if errors.any?
    end

    private

    def perform_mutation(item)
      mutation = <<~MUTATION
        mutation translationsRegister($resourceId: ID!, $translations: [TranslationInput!]!) {
          translationsRegister(
            resourceId: $resourceId,
            translations: $translations
          ) {
            userErrors {
              field
              message
            }
          } 
        }
      MUTATION
      variables = {
        resourceId: item[:resourceId],
        translations: item[:translations]
      }
      integration = user.integrations.find(shopify_id)
      fail!(errors: "No Shopify store connected!") unless integration
      session = ShopifyAPI::Auth::Session.new(
        shop: integration.domain,
        access_token: integration.token,
      )
      ShopifyAPI::Context.activate_session(session)
      client = ShopifyAPI::Clients::Graphql::Admin.new(session: session)
      response = client.query(query: mutation, variables: variables)
      response.body["data"]["translationsRegister"]
    end
  end
end
