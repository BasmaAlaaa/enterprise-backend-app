class AddDefaultToProviderUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :provider, from: nil, to: 'web'
  end
end
