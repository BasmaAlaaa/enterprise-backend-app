class AccountOwnerPolicy < ApplicationPolicy
  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    same_user?
  end

  def create?
    false
  end

  def update?
    same_user?
  end

  def destroy?
    false
  end

  private

  def account_owner?
    @user == @record.account_owner
  end

  def same_user?
    @user && @record == @user
  end
end

class AccountOwnerPolicy::Scope
  attr_reader :user, :scope

  def initialize(user, scope)
    @user = user
    @scope = scope
  end

  def resolve
    scope.none
  end
end