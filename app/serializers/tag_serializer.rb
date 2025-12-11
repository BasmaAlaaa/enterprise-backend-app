class TagSerializer < ActiveModel::Serializer
    attributes :id, :name, :created_at, :updated_at
    # Include any other attributes or associations as needed
  end