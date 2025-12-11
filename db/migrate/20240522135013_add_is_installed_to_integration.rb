class AddIsInstalledToIntegration < ActiveRecord::Migration[7.0]
  def change
    add_column :integrations, :is_installed, :boolean, default: true
  end
end
