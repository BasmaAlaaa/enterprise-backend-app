FactoryBot.define do
  factory :account_owner do
    sequence(:name) { |n| "AccountOwner #{n}" }
    sequence(:email) { |n| "email#{n}@example.com" }
    password { "password" }
  end
end
