class AddTestUserToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :test_user, :boolean, default: true
  end
end
