FactoryBot.define do
  factory :subscription do
    remaining_generations { 1000 }
    status { 0 }
    stripe_id { "MyString" }
    end_date { 1.year.from_now }
    remaining_images { 1 }
    renew_date { 1.year.from_now }
    association :account_owner
    association :subscription_plan
  end
end
   