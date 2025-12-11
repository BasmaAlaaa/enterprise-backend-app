module SubscriptionPlans
  class Cancel
    include Interactor

    delegate :user, :fail!, to: :context

    def call
      subscription = user.subscription
      fail!(errors: 'You are not assigned to a plan') if subscription.blank?
      return subscription.canceled! if subscription.free_plan?

      cancel_local_subscription(subscription)
      cancel_stripe_subscription(subscription) if subscription.stripe_id.present?
    end

    private

    def cancel_stripe_subscription(subscription)
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      result = Stripe::Subscription.cancel(subscription.stripe_id)
      
      if result.status == 'canceled'
        subscription.canceled!
      else
        fail!(errors: 'Failed to cancel Stripe subscription')
      end
    rescue Stripe::StripeError => e
      fail!(errors: e.message)
    end

    def cancel_local_subscription(subscription)
      if subscription.update(status: :canceled)
        context.message = "Subscription canceled successfully"
      else
        fail!(errors: subscription.errors.full_messages)
      end
    end
  end
end