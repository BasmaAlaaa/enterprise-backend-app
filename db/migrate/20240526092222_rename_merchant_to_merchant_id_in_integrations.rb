class RenameMerchantToMerchantIdInIntegrations < ActiveRecord::Migration[7.0]
  def change
    rename_column :integrations, :merchant, :merchant_id
  end
end
