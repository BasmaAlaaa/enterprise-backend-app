class Api::AdminStatisticsController < Api::BaseController

  before_action :authorize_shop_domain

  def index
    start_date = params[:start_date] || Date.today.beginning_of_day
    end_date = params[:end_date] || Date.today.end_of_day

    payments = Payment.joins(:account_owner).where(created_at: start_date..end_date).select(:amount, "users.name as account_owner_name", "users.email as account_owner_email")
    users = User.where(created_at: start_date..end_date).select(:name, :email)
    generations = Generation.done.joins(:integration).where(created_at: start_date..end_date).select(:generation_type, "integrations.domain as integration_domain")
    render(json: {payments: payments, installs: users, generations: generations})
  end

  private

  def authorize_shop_domain
    return if current_user.email == "zeiadhelmyharidy@gmail.com"
    render json: { errors: "You are not allowed to do this action"}, status: :unauthorized
  end
end