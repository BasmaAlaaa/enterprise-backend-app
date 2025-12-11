class DropStatisticsTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :statistics
  end
end