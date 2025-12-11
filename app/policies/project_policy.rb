class ProjectPolicy < ApplicationPolicy
  def initialize(user, record)
    @user = user
    @record = record
  end
  def create?
    user.account_owner? || belongs_to_user?
  end

  def update?
    user_associated_with_project?
  end

  def destroy?
    user.account_owner?  
  end

  def show?
    user_associated_with_project?
  end

  def assign_team_members?
    user.account_owner?

  end


  private

  def user_associated_with_project?
    record.client.account_owner == user ||
    record.users.exists?(id: user.id)
  end

  def belongs_to_user?
    user.clients.include?(record.client)
  end

  
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      user.projects
    end
  end
end

                                                                                        