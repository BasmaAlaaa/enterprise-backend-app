class IntegrationSerializer < ActiveModel::Serializer
    attributes :id, :name, :integration_type, :domain, :created_at, :updated_at
    # Include any other attributes or associations as needed
  end