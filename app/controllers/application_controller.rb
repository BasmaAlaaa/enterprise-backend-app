class ApplicationController < ActionController::Base

  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  respond_to :json
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  before_action :set_current_user
  include PaginationHelper
  private

  def user_not_authorized
    render json: { error: 'Not authorized' }, status: :forbidden
  end

  def render_not_found(exception)
    render json: { error: "Record not found: #{exception.message}" }, status: :not_found
  end

  def set_current_user
    @user = current_user
  end
      
end
