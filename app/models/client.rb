class Client < ApplicationRecord
    has_many :projects
    belongs_to :account_owner, class_name: 'AccountOwner', foreign_key: 'user_id'
    has_many :integrations, dependent: :destroy
    has_one :subscription, through: :account_owner

    # scope :by_integrations, -> (types) {joins(:integrations).where(integrations: {name: names})}
    scope :by_name, -> (name) {where("clients.name like '%#{name}%'")}
end
       