class Integrations::Shopify::BulkUpdate::BatchMutation
  include Interactor

  delegate :user, :shopify_id, :staged_target, :fail!, to: :context
  def call
    staged_upload_path = staged_target["parameters"][3]["value"]
    mutation = <<~QUERY
    mutation {
      bulkOperationRunMutation(
        mutation: "#{mutation_schema}",
        stagedUploadPath: "#{staged_upload_path}") {
        bulkOperation {
          id
          url
          status
        }
        userErrors {
          message
          field
        }
      }
    }
  QUERY

  integration = user.integrations.find(shopify_id)
  fail!(errors: "No Shopify store connected!") unless integration
  session = ShopifyAPI::Auth::Session.new(
    shop: integration.domain,
    access_token: integration.token,
  )
  ShopifyAPI::Context.activate_session(session)
  client = ShopifyAPI::Clients::Graphql::Admin.new(session: session)
  results = client.query(query: mutation).body

  errors = results["data"]["bulkOperationRunMutation"]["userErrors"]
  fail!(errors: errors.join(",")) if errors.present?
  end

  private

  def mutation_schema
  end
end