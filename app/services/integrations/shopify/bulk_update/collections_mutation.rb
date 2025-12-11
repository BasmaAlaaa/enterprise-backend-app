class Integrations::Shopify::BulkUpdate::CollectionsMutation < Integrations::Shopify::BulkUpdate::BatchMutation
  include Interactor

  private

  def mutation_schema
    "mutation call($input: CollectionInput!) { collectionUpdate(input: $input) { collection {id} userErrors { message field } } }"
  end
end