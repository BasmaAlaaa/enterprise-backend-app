module Integrations::Salla
  class CreateUser
    include Interactor

    delegate :shop, :fail!, to: :context

    def call
      fail!("Shop is required") unless shop

      email = shop.email
      fail!("Cannot create user without email") unless email

      password = Devise.friendly_token.first(12)

      user = User.find_or_initialize_by(email: email)

      if user.new_record?
        user.assign_attributes(password: password, password_confirmation: password)
        user.save!
        UserMailer.welcome_email(user, password).deliver_later
      end

      shop.update!(user: user)

      context.user = user
    rescue ActiveRecord::RecordInvalid => e
      fail!(message: e.message)
    end
  end
end
