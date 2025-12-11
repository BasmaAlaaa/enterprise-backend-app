class RenameIntegrationType < ActiveRecord::Migration[7.0]
  def change
    rename_column :integrations, :type, :integration_type
  end
end
