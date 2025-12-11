class AddBatchStatusToBatchGroup < ActiveRecord::Migration[7.0]
  def change
    add_column :batch_groups, :batch_status, :string
    add_column :batch_groups, :batch_request_counts, :jsonb
  end
end
