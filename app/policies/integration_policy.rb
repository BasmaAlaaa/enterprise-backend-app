class IntegrationPolicy < ApplicationPolicy

  def initialize(user, record)
    @user = user
    @record = record
  end
  
  def create?
    user.account_owner?  
  end

  def assign_client?
    user.account_owner?  && user.clients.exists?(id: record.client_id)
  end

  def update?
    user.account_owner?
  end

  def destroy?
    user.account_owner?  
  end

  def show?
    user.account_owner?  
  end

  def index?
    user.account_owner?  
  end

  def assign_main_client?
    user.account_owner?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.account_owner?
        user.integrations      
      else
        scope.none
      end
    end
  end
end