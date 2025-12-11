class RenameWordsToGeneration < ActiveRecord::Migration[7.0]
  def change
    unlimited_benefits = SubscriptionPlan.find_by(name: "Unlimited").benefits
    unlimited_benefits[:generations_per_month] = 7000
    pro_benefits = SubscriptionPlan.find_by(name: "Pro").benefits
    pro_benefits[:generations_per_month] = 3000
    basic_benefits = SubscriptionPlan.find_by(name: "Basic").benefits
    basic_benefits[:generations_per_month] = 300
    free_benefits = SubscriptionPlan.find_by(name: "Free").benefits
    free_benefits[:generations_per_month] = 50

    SubscriptionPlan.where(name: "Unlimited").update(benefits: unlimited_benefits, total_words_per_month: 7000)

    SubscriptionPlan.where(name: "Pro").update(benefits: pro_benefits, total_words_per_month: 3000)

    SubscriptionPlan.where(name: "Basic").update(benefits: basic_benefits, total_words_per_month: 300)
    SubscriptionPlan.where(name: "Free").update(benefits: free_benefits, total_words_per_month: 50)
  end
end