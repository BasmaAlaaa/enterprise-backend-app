class Tag < ApplicationRecord
    has_many :tag_projects
    has_many :projects, through: :tag_projects
    belongs_to :account_owner, class_name: 'User', foreign_key: 'user_id'
end
