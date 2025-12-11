class AddFreePlanUsedToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :free_trial_used, :boolean, default: :false
  end
end
