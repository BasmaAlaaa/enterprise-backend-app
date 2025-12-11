class Integrations::Shopify::BulkUpdate::ProductsMutation < Integrations::Shopify::BulkUpdate::BatchMutation
  include Interactor

  private

  def mutation_schema
    "mutation call($input: ProductInput!) { productUpdate(input: $input) { product {id} userErrors { message field } } }"
  end
end