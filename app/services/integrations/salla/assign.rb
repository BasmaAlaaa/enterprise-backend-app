module Integrations
  module Salla
    class Assign
      include Interactor::Organizer

      organize Integrations::Salla::FetchStoreDomain, Integrations::Salla::FetchUserEmail, Integrations::Salla::AccessToken, Integrations::CreateAccountOwnerAndStatistics
    end
  end
end
