module Integrations
  module Salla
    class HandleStoreSubscriptionStarted
      include Interactor

      delegate :params, :integration, :fail!, to: :context

      def call
        data = params[:data]
        fail!(errors: "Integration not found") if integration.blank?
        user = integration.account_owner
        subscription_plan = SubscriptionPlan.find_by(name: data[:plan_name], subscription_type: "monthly")
        fail!(errors: "Subscription plan not found") if subscription_plan.blank?
        user.subscription&.canceled!

        subscription = Subscription.new(
          user_id: user.id,
          subscription_plan: subscription_plan,
          status: :active,
          end_date: data[:end_date] || Date.today + 1.month,
          renew_date: data[:end_date] || Date.today + 1.month,
          remaining_generations: subscription_plan.benefits["generations_per_month"],
          remaining_images: subscription_plan.benefits["images_per_month"]
        )

        fail!(errors: subscription.errors.full_messages) unless subscription.save
      end
    end
  end
end
