class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.decimal :remaining_words ,null: false
      t.integer :status ,null: false
      t.string :stripe_id
      t.date :end_date
      t.integer :remaining_images
      t.date :renew_date
      t.references :user
      t.references :subscription_discount
      t.references :subscription_plan
      t.timestamps
    end
  end
end
