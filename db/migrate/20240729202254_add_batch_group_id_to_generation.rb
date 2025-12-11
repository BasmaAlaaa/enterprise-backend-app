class AddBatchGroupIdToGeneration < ActiveRecord::Migration[7.0]
  def change
    add_reference :generations, :batch_group, foreign_key: true
  end
end
