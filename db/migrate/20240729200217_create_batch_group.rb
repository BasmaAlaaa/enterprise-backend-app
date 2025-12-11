class CreateBatchGroup < ActiveRecord::Migration[7.0]
  def change
    create_table :batch_groups do |t|
      t.string :name
      t.integer :status
      t.string :batch_id
      t.integer :generation_type
      t.references :integration, null: false, foreign_key: true
      t.timestamps
    end
  end
end
