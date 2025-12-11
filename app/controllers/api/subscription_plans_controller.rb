class Api::SubscriptionPlansController < Api::BaseController
  def index
    authorize SubscriptionPlan
    render(json: { subscription_plans: SubscriptionPlan.order(:amount) })
  end

  def validate_discount
    result = ::SubscriptionDiscounts::Validate.call(code: params[:code],user: current_user)
    if result.success?
      render(json: { subscription_discount: result.discount })
    else
      render json: {errors: result.errors}, status: :unprocessable_entity
    end
  end
end