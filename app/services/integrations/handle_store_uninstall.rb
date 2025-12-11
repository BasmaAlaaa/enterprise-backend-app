module Integrations
  class HandleStoreUninstall
    include Interactor

    delegate :integration, :fail!, to: :context

    def call
      fail!(errors: "Integration not found") if integration.blank?
      integration.update(is_installed: false)
      integration.account_owner.destroy
      fail!(errors: integration.errors.full_messages) unless integration.save
    end
  end
end
