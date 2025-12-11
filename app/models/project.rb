class Project < ApplicationRecord
    belongs_to :client
    has_many :tag_projects
    has_many :tags, through: :tag_projects
    has_many :user_projects
    has_many :users, through: :user_projects
    has_many :integrations, through: :client
    has_many :generations

    scope :by_tags, -> (names) {joins(:tags).where(tags: {name: names})}
    scope :by_name, -> (name) {where("projects.name like '%#{name}%'")}
    scope :by_client, -> (name) {joins(:client).where(client: {name: name})}

end
