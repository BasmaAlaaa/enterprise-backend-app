class AddErrorsMessageToGenerations < ActiveRecord::Migration[7.0]
  def change
    add_column :generations, :errors_message, :text
  end
end
