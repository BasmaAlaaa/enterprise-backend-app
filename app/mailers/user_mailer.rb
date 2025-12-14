class UserMailer < ApplicationMailer
  default from: 'admin@yozo.ai'

  def welcome_email(user, password)
    @user = user
    @password = password
    @url = 'https://enterprise.yozo.ai/dashboard'

    mail(
      to: @user.email,
      subject: 'Get Started with Scribe AI!'
    )
  end
end
