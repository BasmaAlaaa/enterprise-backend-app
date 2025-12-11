class SubscriptionPolicy < ApplicationPolicy
  def initialize(user, record)
    @user = user
    @record = record
  end

  def create?
    user.account_owner?  
  end
end