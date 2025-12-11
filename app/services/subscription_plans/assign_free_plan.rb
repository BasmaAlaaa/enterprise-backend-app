module SubscriptionPlans
  class AssignFreePlan
    include Interactor

    delegate :user, :fail!, to: :context
    def call
      fail!(errors: 'You already have a plan') if user.subscription.present?

      plan = SubscriptionPlan.find_by!(name: 'Free')
      subscription = Subscription.new(
        status: :active,
        subscription_plan_id: plan.id,
        user_id: user.id,
        remaining_generations: plan.benefits["generations_per_month"],
        remaining_images: plan.benefits["images_per_month"],
        end_date: Date.today + 29.days
      )
      fail!(errors: subscription.errors) unless subscription.save
      context.url = ENV["FREE_SUBSCRIPTION_REDIRECTION_URL"]
    end
  end
end