module Integrations::Shopify::BulkUpdate::Organizers
  class ProductsMedia
    include Interactor::Organizer
    include Integrations::Shopify::BulkUpdate
    organize RequestStagingUrl, UploadFileToShopify, ProductsMediaMutation
  end
end
