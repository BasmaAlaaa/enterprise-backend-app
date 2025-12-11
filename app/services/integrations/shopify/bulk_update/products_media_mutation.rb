class Integrations::Shopify::BulkUpdate::ProductsMediaMutation < Integrations::Shopify::BulkUpdate::BatchMutation
  include Interactor

  private

  def mutation_schema
    "mutation call($media: [UpdateMediaInput!]!, $productId: ID!) { productUpdateMedia(media: $media, productId: $productId) { media {alt} userErrors { message field } } }"
  end
end