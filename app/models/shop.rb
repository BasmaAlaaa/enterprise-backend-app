class Shop < ApplicationRecord
  belongs_to :user, optional: true

  enum provider: {
    salla: 0,
    shopify: 1
  }
end
