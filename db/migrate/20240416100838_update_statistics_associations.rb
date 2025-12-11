class UpdateStatisticsAssociations < ActiveRecord::Migration[7.0]
  def change
    remove_column :statistics, :integration_id, :integer
    add_column :statistics, :user_id, :integer
  end
end
