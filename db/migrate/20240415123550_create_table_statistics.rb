class CreateTableStatistics < ActiveRecord::Migration[7.0]
  def change
    create_table :statistics do |t|
      t.integer :products_titles, default: 0
      t.integer :products_seo, default: 0
      t.integer :products_description, default: 0
      t.integer :collection_description, default: 0
      t.integer :collection_seo, default: 0
      t.integer :article_content, default: 0
      t.integer :article_excerpt, default: 0
      t.integer :article_seo, default: 0
      t.integer :images, default: 0
      t.references :integration, null: false
      t.integer :image_alt_text, default: 0
      t.decimal :total_words, default:0
      t.timestamps
    end
  end
end
