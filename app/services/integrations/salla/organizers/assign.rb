module Integrations
  module Salla
    module Organizers
      class Assign
        include Interactor::Organizer

        organize Integrations::Salla::FetchUserEmail, Integrations::Salla::CreateShop, CreateUser
      end
    end
  end
end
