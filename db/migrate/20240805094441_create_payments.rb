class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.decimal :amount
      t.string :reference_number
      t.references :subscription_discount
      t.references :subscription_plan
      t.references :subscription
      t.integer :status
      t.timestamps
    end
  end
end
