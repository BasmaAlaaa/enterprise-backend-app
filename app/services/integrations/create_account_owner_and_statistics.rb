module Integrations
  class CreateAccountOwnerAndStatistics
    include Interactor

    delegate :integration, :name, :email, to: :context

    def call
      account_owner = AccountOwner.find_or_create_account_owner(name, email)
      create_statistics!(integration)
      assign_main_client!(integration, account_owner)
    end

    private
    
    def create_statistics!(integration)
      Statistics.create(integration: integration) unless integration.statistics.present?
    end

    def assign_main_client!(integration, account_owner)
      client = account_owner.clients.find_by(name: "Main")
      integration.update(client: client)
    end
  end
end
