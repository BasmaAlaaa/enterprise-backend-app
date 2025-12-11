class Keyword < ApplicationRecord
  belongs_to :integration
  validates_presence_of :name, :integration_id
  validates_uniqueness_of :name, scope: :integration_id

  scope :search_by_name, -> (name) { where("name ILIKE ?", "%#{name}%") }
end
