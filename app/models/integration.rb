class Integration < ApplicationRecord
    belongs_to :client, optional: true
    has_many :generations, dependent: :destroy
    has_one :account_owner, through: :client
    has_one :subscription ,through: :account_owner
    has_one :statistics, dependent: :destroy
    has_many :keywords, dependent: :destroy

    enum integration_type: { salla: 0, shopify: 1, wordpress: 2 }
end
