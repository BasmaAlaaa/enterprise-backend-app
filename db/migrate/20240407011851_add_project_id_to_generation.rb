class AddProjectIdToGeneration < ActiveRecord::Migration[7.0]
  def change
    add_reference :generations, :project, null: true, foreign_key: true
  end
end
