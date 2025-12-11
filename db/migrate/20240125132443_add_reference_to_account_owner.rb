class AddReferenceToAccountOwner < ActiveRecord::Migration[7.0]
  def change
    remove_reference :tags, :user, foreign_key: true
    remove_reference :integrations, :user, foreign_key: true

    add_reference :tags, :account_owner, foreign_key: { to_table: :users }
    add_reference :integrations, :account_owner, foreign_key: { to_table: :users }
  end
end
