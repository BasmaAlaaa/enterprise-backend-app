class AddBatchIdToGenerations < ActiveRecord::Migration[7.0]
  def change
    add_column :generations, :batch_id, :string
    add_column :generations, :published, :boolean, default: false
  end
end
