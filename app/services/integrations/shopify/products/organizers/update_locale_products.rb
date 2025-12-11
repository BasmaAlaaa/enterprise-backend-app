module Integrations::Shopify::Products
  class Organizers::UpdateLocaleProducts
    include Interactor::Organizer
     organize Show, PublishTranslation
  end
end
