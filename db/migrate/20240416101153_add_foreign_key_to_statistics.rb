class AddForeignKeyToStatistics < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :statistics, :users, column: :user_id
  end
end
