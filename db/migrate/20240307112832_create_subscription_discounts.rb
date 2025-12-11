class CreateSubscriptionDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :subscription_discounts do |t|
      t.string :code , null: false
      t.decimal :percentage , null: false
      t.timestamps
    end
  end
end
