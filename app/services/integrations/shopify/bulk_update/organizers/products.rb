module Integrations::Shopify::BulkUpdate::Organizers
  class Products
    include Interactor::Organizer
    include Integrations::Shopify::BulkUpdate
    organize RequestStagingUrl, UploadFileToShopify, ProductsMutation
  end
end
