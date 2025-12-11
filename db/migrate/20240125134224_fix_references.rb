class FixReferences < ActiveRecord::Migration[7.0]
  def change

    remove_reference :tags, :account_owner, foreign_key: { to_table: :users }
    remove_reference :integrations, :account_owner, foreign_key: { to_table: :users }
    remove_reference :clients, :account_owner, foreign_key: { to_table: :users }
    remove_reference :users, :account_owner, foreign_key: { to_table: :users }

    add_reference :integrations, :user, foreign_key: true
    add_reference :clients, :user, foreign_key: true
    add_reference :tags, :user, foreign_key: true
    add_reference :users, :user, foreign_key: true


  end
end
