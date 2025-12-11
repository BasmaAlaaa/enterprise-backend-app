# app/policies/client_policy.rb

class ClientPolicy < ApplicationPolicy

  def initialize(user, record)
    @user = user
    @record = record
  end

  def create?
    user.account_owner?
  end

  def update?
    account_owner_can_manage?
  end

  def destroy?
    account_owner_can_manage?
  end

  def show?
    account_owner_can_manage? || belongs_to_user?
  end

  private

  def account_owner_can_manage?
    record.user_id == user.id
  end

  def belongs_to_user?
    user.clients.include?(record)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      user.clients
    end
  end
end
