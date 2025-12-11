class RenameTotalWordsPerMonth < ActiveRecord::Migration[7.0]
  def change
    rename_column :subscription_plans, :total_words_per_month, :total_generations_per_month
    rename_column :subscriptions, :remaining_words, :remaining_generations
  end
end