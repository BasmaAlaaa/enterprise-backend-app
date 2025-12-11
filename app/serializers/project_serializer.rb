class ProjectSerializer < ActiveModel::Serializer
    attributes :id, :name, :created_at, :updated_at
    belongs_to :client
    has_many :tags
    has_many :users
    has_many :integrations
  end