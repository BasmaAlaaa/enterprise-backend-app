module SubscriptionPlans
  class Renew
    include Interactor

    delegate :user, :fail!, to: :context
    def call
      subscription = user.subscription
      fail!(errors: "No subscription found") if subscription.blank?
      subscription_plan = subscription.subscription_plan
      subscription.renewed!

      new_subscription = Subscription.new(
        user_id: user.id,
        subscription_plan: subscription_plan,
        status: :active,
        remaining_generations: subscription_plan.benefits["generations_per_month"],
        remaining_images: subscription_plan.benefits["images_per_month"],
        renew_date: Date.today + 1.month,
        end_date: subscription_plan.monthly? ? Date.today + 1.month : Date.today + 1.year 
      )

      fail!(errors: new_subscription.errors) unless new_subscription.active!
    end
  end
end