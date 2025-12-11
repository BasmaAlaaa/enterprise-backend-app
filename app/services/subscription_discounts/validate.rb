module SubscriptionDiscounts
  class Validate
    include Interactor

    delegate :code, :fail!, to: :context
    def call
      discount = SubscriptionDiscount.find_by(code: code)
      fail!(errors: 'Subscription Discount not found') if discount.blank?
      context.discount = discount
    end
  end
end