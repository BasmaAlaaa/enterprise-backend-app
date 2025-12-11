module SubscriptionDiscounts
  class Use
    include Interactor

    delegate :code, :user, :subscription_plan_id, :fail!, to: :context
    def call
      discount = SubscriptionDiscount.find_by(code: code)
      fail!(errors: 'Subscription Discount not found') if discount.blank?
    end
  end
end