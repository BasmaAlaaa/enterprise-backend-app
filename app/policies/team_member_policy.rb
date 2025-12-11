class TeamMemberPolicy < ApplicationPolicy
  def initialize(user, record)
    @user = user
    @record = record
  end
  def index?
    account_owner?
  end

  def show?
    account_owner? || same_user?
  end

  def create?
    account_owner?
  end

  def update?
    account_owner? || same_user?
  end

  def destroy?
    account_owner? & !same_user?
  end

  private

  def account_owner?
    @record.team_member? && @user == @record.account_owner
  end

  def same_user?
    @user && @record == @user
  end
end

class TeamMemberPolicy::Scope
  attr_reader :user, :scope

  def initialize(user, scope)
    @user = user
    @scope = scope
  end

  def resolve
    if user && user.account_owner?
      scope.where(user_id: user.id)
    else
      scope.none
    end
  end
end