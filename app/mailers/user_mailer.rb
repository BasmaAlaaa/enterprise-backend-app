class UserMailer < ApplicationMailer
  default from: 'admin@yozo.ai'

  def welcome_email(email, password)
    @email = email
    @password = password
    @url = 'https://enterprise.yozo.ai/dashboard'

    mail(
      to: @email,
      subject: 'Get Started with Scribe AI!'
    )
  end
end
