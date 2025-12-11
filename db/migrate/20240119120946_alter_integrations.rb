class AlterIntegrations < ActiveRecord::Migration[7.0]
  def change
    add_column :integrations, :type, :integer
    add_column :integrations, :token, :string
    add_column :integrations, :refresh_token, :string
    add_column :integrations, :domain, :string
    add_column :integrations, :domain_id, :string

  end
end
