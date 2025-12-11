class SubscriptionPlanPolicy < ApplicationPolicy
  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user.account_owner?  
  end
end