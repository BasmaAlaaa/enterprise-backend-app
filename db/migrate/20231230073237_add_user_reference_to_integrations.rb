class AddUserReferenceToIntegrations < ActiveRecord::Migration[7.0]
  def change
    add_reference :integrations, :user, null: false, foreign_key: true
  end
end
