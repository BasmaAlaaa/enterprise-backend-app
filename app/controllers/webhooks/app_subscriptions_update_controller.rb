class Webhooks::AppSubscriptionsUpdateController < WebhooksController
  def create
    event = Stripe::Event.construct_from(params.as_json)
    return unless event.type == 'customer.subscription.updated'
    handle_subscription_updated(event.data.object)

    head :ok # Acknowledge the webhook event was received
  end

  private

  def handle_subscription_updated(stripe_subscription)
    user = User.find_by(stripe_customer_id: stripe_subscription.customer)
    return if user.blank?

    subscription = user.subscriptions.pending.last
    return if subscription.blank?
   
    return subscription.canceled! if stripe_subscription.status != 'active'

    subscription_plan_id = subscription.subscription_plan_id
    
    if subscription.subscription_discount.present? && subscription.pending?
      result = SubscriptionDiscounts::Orgainzers::Use.call(
        code: subscription.subscription_discount.code,
        subscription_plan_id: subscription_plan_id,
        user: user,
        subscription: subscription,
        stripe_id: stripe_subscription.id
      )
    else
      result = SubscriptionPlans::Assign.call(user: user, subscription: subscription, stripe_id: stripe_subscription.id )
    end

    return subscription.canceled! unless result.success?
    Payment.create(subscription: subscription, status: :done, amount: amount(subscription))
  end

  def amount(subscription)
    subscription_plan = subscription.subscription_plan
    discount = subscription.subscription_discount
    return subscription_plan.amount if discount.blank?
    subscription_plan.amount - (subscription_plan.amount * discount.percentage / 100)
  end
end
