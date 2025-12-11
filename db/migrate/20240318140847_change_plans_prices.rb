class ChangePlansPrices < ActiveRecord::Migration[7.0]
  def change
    
    SubscriptionPlan.where(name: "Free").update(
      benefits: {
        languages: ["English"],
        words_per_month: 5000,
        images_per_month: 0,
        contact_support: ["Email support"]
    })
    SubscriptionPlan.where(name: "Pro", subscription_type: :monthly).update(amount: 69.99)
    SubscriptionPlan.where(name: "Pro", subscription_type: :yearly).update(amount: 671.90)

    SubscriptionPlan.where(name: "Basic", subscription_type: :monthly).update(amount: 14.99)
    SubscriptionPlan.where(name: "Basic", subscription_type: :yearly).update(amount: 143.90)

    SubscriptionPlan.where(name: "Unlimited", subscription_type: :monthly).update(amount: 189.99)
    SubscriptionPlan.where(name: "Unlimited", subscription_type: :yearly).update(amount: 1823.90)

    SubscriptionPlan.where(name: "Annual Basic").update_all(name: "Basic")
    SubscriptionPlan.where(name: "Annual Pro").update_all(name: "Pro")
    SubscriptionPlan.where(name: "Annual Unlimited").update_all(name: "Unlimited")

    SubscriptionPlan.where(name: "Unlimited").update(
      benefits: {
        languages: ["English", "Spanish", "Arabic", "German", "French"],
        words_per_month: 1000000,
        images_per_month: 100,
        contact_support: ["Live Chat", "Email support", "Priority Support"]
      })

    SubscriptionPlan.where(name: "Pro").update(
      benefits: {
        languages: ["English", "Spanish", "Arabic", "German", "French"],
        words_per_month: 500000,
        images_per_month: 50,
        contact_support: ["Live Chat", "Email support", "Priority Support"]
      })

    SubscriptionPlan.where(name: "Basic").update(
      benefits: {
        languages: ["English", "Spanish", "Arabic", "German", "French"],
        words_per_month: 50000,
        images_per_month: 0,
        contact_support: ["Email support"]
      })


  end
end
