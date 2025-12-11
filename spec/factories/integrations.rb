FactoryBot.define do
  factory :integration do
    association :account_owner
    name { "Integration-test" }
  end
end