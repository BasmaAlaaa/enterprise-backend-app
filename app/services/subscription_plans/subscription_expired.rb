module SubscriptionPlans
  class SubscriptionExpired
    include Interactor

    delegate :integration, :fail!, to: :context

    def call        
      fail!(errors: "Integration not found") if integration.blank?
      subscription = integration.account_owner.subscription
      fail!(errors: "You are not assigned to a plan") if subscription.blank?
      subscription.update(status: :expired)
      fail!(errors: subscription.errors.full_messages) unless subscription.save
    end
  end
end
