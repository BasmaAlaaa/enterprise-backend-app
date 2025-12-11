module SubscriptionDiscounts
  class Orgainzers::Use
    include Interactor::Organizer
    include Interactor::Transactionable

    organize SubscriptionDiscounts::Use,
    SubscriptionPlans::Assign
  end
end