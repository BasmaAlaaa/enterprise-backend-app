class AddMerchantToIntegration < ActiveRecord::Migration[7.0]
  def change
    add_column :integrations, :merchant, :integer
  end
end
