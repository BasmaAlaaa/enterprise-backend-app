class AddIsStoreToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_store, :boolean, default: false
  end
end
