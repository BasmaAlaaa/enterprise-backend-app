class CreateShops < ActiveRecord::Migration[7.0]
  def change
    create_table :shops do |t|
      t.integer :provider, null: false
      t.string :access_token, null: false
      t.string :refresh_token
      t.string :access_scopes, default: "", null: false
      t.string :name
      t.string :email
      t.string :domain

      t.boolean :uninstalled, default: false

      t.timestamps
    end

    add_index :shops, :provider
    add_index :shops, :domain, unique: true
  end
end