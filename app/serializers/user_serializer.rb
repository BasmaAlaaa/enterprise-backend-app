class UserSerializer < ActiveModel::Serializer
    attributes :id, :name, :email, :created_at, :updated_at, :free_trial_used, :test_user
    # Include any other attributes or associations as needed
  end