class CreateGenerations < ActiveRecord::Migration[7.0]
  def change
    create_table :generations do |t|
      t.references :integration, null: false, foreign_key: true
      t.integer :status
      t.integer :generation_type
      t.json :old_content
      t.json :content

      t.timestamps
    end
  end
end
