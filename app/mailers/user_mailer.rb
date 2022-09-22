class UserMailer < ApplicationMailer
	default from: 'notifications@example.com'

  def send_otp_email(user, otp_code)
    @user = user
    @url  = 'http://example.com/login'
    @otp_code = otp_code
    mail(to: @user.email, subject: 'Welcome to My Friends Quiz')
  end
end