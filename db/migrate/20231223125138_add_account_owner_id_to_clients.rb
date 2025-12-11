class AddAccountOwnerIdToClients < ActiveRecord::Migration[7.0]
  def change
    add_reference :clients, :users, foreign_key: { to_table: :users }
  end
end
