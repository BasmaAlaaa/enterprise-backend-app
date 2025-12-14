module Integrations
  module Salla
    class Assign
      include Interactor::Organizer

      organize Integrations::Salla::FetchUserEmail, Integrations::Salla::CreateShop
    end
  end
end
