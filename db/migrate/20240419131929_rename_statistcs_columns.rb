class RenameStatistcsColumns < ActiveRecord::Migration[7.0]
  def change
    rename_column :statistics, :products_titles, :product_title
    rename_column :statistics, :products_seo, :product_seo
    rename_column :statistics, :products_description, :product_description
    add_column :statistics, :article_title, :integer, default: 0
  end
end
