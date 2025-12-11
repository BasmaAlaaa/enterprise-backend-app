class RenameUsersProjects < ActiveRecord::Migration[7.0]
  def change
    rename_table :users_projects, :user_projects
  end
end
