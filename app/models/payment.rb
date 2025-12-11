class Payment < ActiveRecord::Base
  belongs_to :subscription
  has_one :subscription_plan, through: :subscription
  has_one :account_owner, through: :subscription

  enum status: {
    pending: 0,
    failed: 1,
    done: 2,
  }
end