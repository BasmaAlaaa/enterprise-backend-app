class AddAccountOwnerIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :account_owner, foreign_key: { to_table: :users }
  end
end
