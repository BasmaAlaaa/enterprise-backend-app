class CreateKeywords < ActiveRecord::Migration[7.0]
  def change
    create_table :keywords do |t|
      t.string :name
      t.integer :monthly_searches
      t.string :competition
      t.jsonb :monthly_search_volumes
      t.references :integration, null: false
      t.timestamps
    end
    add_index :keywords, [:integration_id, :name], unique: true
  end
end
