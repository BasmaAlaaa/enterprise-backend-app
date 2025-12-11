
class Api::SubscriptionsController < Api::BaseController
  def create
    authorize Subscription
    plan = SubscriptionPlan.find(params[:subscription_plan_id])
    result = SubscriptionPlans::Pay.call(code: params[:code], user:current_user , subscription_plan: plan)
    if result.success?
      render json: { url: result.url || result.res.url }, status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end

  end

  def assign_free_trial
    result = SubscriptionPlans::AssignFreePlan.call(user: current_user)
    if result.success?
      render(json: { message: "Your trial has started"})
    else
      render json: {errors: result.errors}, status: :unprocessable_entity
    end
  end

  def cancel
    result = SubscriptionPlans::Cancel.call(user: current_user)

    if result.success?
      render(json: { success: true })
    else
      render json: {errors: result.errors}, status: :unprocessable_entity
    end

  end

  def current_subscription
    subscription = current_user.subscription
    subscription_plan = current_user.subscription_plan
    if subscription
      render json: { subscription: subscription , subscription_plan: subscription_plan }, status: :ok
    else
      render json: { message: "No active subscription found" }, status: :not_found
    end
  end

  private

end
