class AccountOwner < User
  has_many :team_members, class_name: 'TeamMember', foreign_key: 'user_id', dependent: :destroy
  has_many :clients, foreign_key: 'user_id', dependent: :destroy
  has_many :projects, through: :clients
  has_many :integrations, through: :clients
  has_many :tags, foreign_key: 'user_id', dependent: :destroy
  has_one :subscription , ->{ active } , foreign_key: 'user_id'
  has_one :subscription_plan, through: :subscription 
  has_many :subscriptions, foreign_key: 'user_id', dependent: :destroy
  has_many :payments, through: :subscriptions
  validates :stripe_customer_id, uniqueness: true, allow_blank: true

  after_create :create_client
  
  private

  def create_client
    Client.create(user_id: self.id, name: 'Main')
  end

  def self.find_or_create_account_owner(name, email)
    account_owner = AccountOwner.find_by(email: email)
    if account_owner.blank?
      hex_password = SecureRandom.hex(10)
      account_owner = AccountOwner.create(name: name, email: email, password: hex_password, is_store: true)
      UserMailer.welcome_email(email, hex_password).deliver_later
    end
    account_owner
  end

end