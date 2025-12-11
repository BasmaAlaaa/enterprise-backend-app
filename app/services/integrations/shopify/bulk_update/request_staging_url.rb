class Integrations::Shopify::BulkUpdate::RequestStagingUrl
  include Interactor

  delegate :user, :shopify_id, :fail!, to: :context
  def call
    integration = user.integrations.find(shopify_id)
    fail!(errors: "No Shopify store connected!") unless integration
    session = ShopifyAPI::Auth::Session.new(
      shop: integration.domain,
      access_token: integration.token,
    )
    ShopifyAPI::Context.activate_session(session)
    client = ShopifyAPI::Clients::Graphql::Admin.new(session: session)
    mutation = <<~QUERY
      mutation {
        stagedUploadsCreate(input:{
          resource: BULK_MUTATION_VARIABLES,
          filename: "#{integration.domain}_bulk_op_vars",
          mimeType: "text/jsonl",
          httpMethod: POST
        }){
          userErrors{
            field,
            message
          },
          stagedTargets{
            url,
            resourceUrl,
            parameters {
              name,
              value
            }
          }
        }
      }
    QUERY
    results = client.query(query: mutation,variables: {}).body

    errors = results["data"]["stagedUploadsCreate"]["userErrors"]
    fail!(errors: errors) if errors.any?
    context.staged_target = results["data"]["stagedUploadsCreate"]["stagedTargets"].first
  end
end