class Subscription < ApplicationRecord
  belongs_to :account_owner, class_name: "AccountOwner", foreign_key: "user_id"
  belongs_to :subscription_plan
  belongs_to :subscription_discount, optional: true
  has_many :payments

  validates_presence_of :status

  validate :user_can_have_only_one_active

  enum status: {
    active: 0,
    canceled: 1,
    renewed: 2,
    due_date: 3,
    pending: 4,
    expired: 5,
    failed: 6
  }

  def free_plan?
    subscription_plan.name == "Free"
  end

  def blog_post?
    ["Unlimited", "Pro", "Free"].include?(subscription_plan.name)
  end

  private
  

  def user_can_have_only_one_active
    return if status != :active 
    return if account_owner.subscriptions.active.count <= 1

    errors.add(status: "User can only have one active subscription")
  end
end
