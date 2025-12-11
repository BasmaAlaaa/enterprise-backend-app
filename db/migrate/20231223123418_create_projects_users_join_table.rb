class CreateProjectsUsersJoinTable < ActiveRecord::Migration[7.0]
  def change
      create_table :users_projects, id: false do |t|
        t.references :project, foreign_key: { on_delete: :cascade }
        t.references :user, foreign_key: { on_delete: :cascade }
        t.timestamps
    end
  end
end
