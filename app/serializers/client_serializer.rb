class ClientSerializer < ActiveModel::Serializer
    attributes :id, :name, :created_at, :updated_at
    has_many :integrations
    # Include any other attributes or associations as needed
  end