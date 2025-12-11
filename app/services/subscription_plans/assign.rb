module SubscriptionPlans
  class Assign
    include Interactor

    delegate :user, :subscription, :stripe_id, :fail!, to: :context
    def call
      fail!(errors: "No subscription found") if subscription.blank?
      user.subscription.renewed! if user.subscription.present?
      subscription.stripe_id = stripe_id
      subscription.renew_date = Date.today + 1.month
      subscription.end_date = subscription.subscription_plan.monthly? ? Date.today + 1.month : Date.today + 1.year 
      fail!(errors: subscription.errors) unless subscription.active!
    end
  end
end