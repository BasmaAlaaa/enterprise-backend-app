FactoryBot.define do
  factory :generation do
    association :integration
    generation_type { :article }
    status { :processing } 
  end
end