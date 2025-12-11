class AddGoogleFieldsToIntegration < ActiveRecord::Migration[7.0]
  def change
    add_column :integrations, :google_access_token, :string
    add_column :integrations, :google_refresh_token, :string
    add_column :integrations, :google_expires_at, :datetime
    add_column :integrations, :google_search_console_site, :string
  end
end
