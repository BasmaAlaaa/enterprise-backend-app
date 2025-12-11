class RemoveUserIdFromIntegrations < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :integrations, column: :user_id  
    remove_column :integrations, :user_id, :integer
  end
end
