class CreateTagProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :tag_projects do |t|
      t.references :tag
      t.references :project
      t.timestamps
    end
  end
end
