class CreateTagsProjectsJoinTable < ActiveRecord::Migration[7.0]
  def change
    def change
      create_table :tags_projects, id: false do |t|
        t.references :project, foreign_key: { on_delete: :cascade }
        t.references :tag, foreign_key: { on_delete: :cascade }
        t.timestamps
      end
    end
  end
end
