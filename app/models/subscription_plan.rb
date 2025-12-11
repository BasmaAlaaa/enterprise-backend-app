class SubscriptionPlan < ApplicationRecord
  validates_uniqueness_of :name, scope: :subscription_type

  validates_presence_of :name, :amount, :subscription_type

  enum subscription_type: {
    monthly: 0,
    yearly: 1
  }

  def free_plan?
    name == "Free"
  end
end
