class CreateSubscriptionPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :subscription_plans do |t|
      t.decimal :amount, null: false
      t.string :name, null: false
      t.integer :subscription_type, null: false
      t.string :info, array: true, default: []
      t.decimal :total_words_per_month
      t.json :benefits
      t.timestamps
    end
  end
end
