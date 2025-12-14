class Shop < ApplicationRecord
  enum provider: {
    salla: 0,
    shopify: 1
  }
end
