module Integrations::Shopify::BulkUpdate::Organizers
  class Collections
    include Interactor::Organizer
    include Integrations::Shopify::BulkUpdate
    organize RequestStagingUrl, UploadFileToShopify, CollectionsMutation
  end
end
