class UserMailer < ApplicationMailer
  default from: 'admin@yozo.ai'

  def welcome_email(email, password)
    Rails.logger.info "UserMailer#welcome_email: email: #{email}, password: #{password}"
    @email = email
    @password = password
    @url = 'https://enterprise.yozo.ai/dashboard'

    mail(
      to: @email,
      subject: 'Get Started with Scribe AI!'
    )
  end
end
