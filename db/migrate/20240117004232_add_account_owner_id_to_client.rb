class AddAccountOwnerIdToClient < ActiveRecord::Migration[7.0]
  def change
    if !ActiveRecord::Base.connection.column_exists?(:clients, :account_owner_id)
      add_reference :clients, :account_owner, foreign_key: { to_table: :users }
    end
  end
end
