FactoryBot.define do
  factory :subscription_plan do
    sequence(:name) { |n| "Plan #{n}" } 
    subscription_type { 1 }
    amount { "9.99" }
    total_generations_per_month { "1000" }
    benefits { "" }
  end
end
