class User < ApplicationRecord
  self.inheritance_column = :role
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable, :registerable,
         :jwt_authenticatable, :omniauthable, :omniauth_providers => [:facebook, :google_oauth2], jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  enum role: { AccountOwner: "AccountOwner", TeamMember: "TeamMember" }
  
  def account_owner?
    self.AccountOwner?
  end

  def team_member?
    self.TeamMember?
  end

  def self.from_omniauth(provider, email, name)
	  find_or_create_by(provider: provider, email: email) do |user|
      user.password = Devise.friendly_token[0,20]
      user.name = name
	  end
  end

end 