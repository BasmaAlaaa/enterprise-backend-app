class CreatePlans < ActiveRecord::Migration[6.1]
  def change
    SubscriptionPlan.destroy_all
    shared_info = ['Bulk generate titles & descriptions', 'Bulk generate collections descriptions',
      'Bulk generate SEO titles & descriptions']
    free_plan = ["5,000 Words per month"] + shared_info + ['English langauge only', 'Email support']
    basic_plan = ["50,000 Words per month"] + shared_info + ["AI SEO blog posts generation", "English, Spanish, Arabic, German, French", "Email support"]
    pro_plan = ["500,000 Words per month"] + shared_info + ["AI SEO blog posts generation", "English, Spanish, Arabic, German, French", "Live Chat, Email support. Priority Support"]
    unlimited_plan = ["Unlimited Words per month"] + shared_info + ["50 Image Credit by AI Dall-E 3 Image Generator",
      "AI SEO blog posts generation", "English, Spanish, Arabic, German, French", "Live Chat, Email support. Priority Support"]

    SubscriptionPlan.create!(subscription_type: :monthly, name: 'Free', amount: 0, total_words_per_month: 5000, info: free_plan)
    SubscriptionPlan.create!(subscription_type: :monthly, name: 'Basic', amount: 11.99, total_words_per_month: 50000, info: basic_plan)
    SubscriptionPlan.create!(subscription_type: :monthly, name: 'Pro', amount: 49.99, total_words_per_month: 500000, info: pro_plan)
    SubscriptionPlan.create!(subscription_type: :monthly, name: 'Unlimited', amount: 89.99, info: unlimited_plan)
    SubscriptionPlan.create!(subscription_type: :yearly, name: 'Annual Basic', amount: 527.99, total_words_per_month: 50000, info: basic_plan)
    SubscriptionPlan.create!(subscription_type: :yearly, name: 'Annual Pro', amount: 527.99, total_words_per_month: 500000, info: pro_plan)
    SubscriptionPlan.create!(subscription_type: :yearly, name: 'Annual Unlimited', amount: 949.99, info: unlimited_plan)
  end
end
