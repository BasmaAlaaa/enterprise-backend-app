class TeamMember < User
  belongs_to :account_owner, class_name: 'AccountOwner', foreign_key: 'user_id'
  has_many :user_projects,  foreign_key: 'user_id'
  has_many :projects, through: :user_projects
  has_many :clients, through: :projects
  has_many :integrations, through: :clients


  scope :by_projects, -> (names) {joins(:projects).where(projects: {name: names})}
  scope :by_name, -> (name) {where("users.name like '%#{name}%'")}
end