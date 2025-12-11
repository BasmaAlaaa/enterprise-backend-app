module Integrations::Shopify::BulkUpdate::Organizers
  class LocaleProducts
    include Interactor::Organizer
    include Integrations::Shopify::Products
    include Integrations::Shopify::BulkUpdate
    organize Index,PrepareLocaleInput,LocaleProductsMutation
   end
end
