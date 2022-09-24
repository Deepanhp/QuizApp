class SessionsController < ApplicationController
	#Deals with authentication
	before_action :require_user, only: [:destroy, :loginVerifyOtp]
	before_action :no_login, except: [:destroy, :loginVerifyOtp]
	def new
		 
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			# if !user.active_session_exists
				session[:user_id] = user.id
				otp = user.otp_code
				if Rails.env == 'development' || Rails.env == 'test'
					UserMailer.send_otp_email(user, otp).deliver_now					
				else
					response = OtpSms.send_otp(otp, user.phone)
					if response["return"]
						flash[:success] = response["message"][0]
					else
					 	user.destroy
						user = nil
						flash[:danger] = "Sending OTP failed, Please retry signing up"
						redirect_to root_path
					end
				end
				render 'loginVerifyOtp'
			# else
			# 	flash[:success] = "You have active login session"
			# 	redirect_to root_path
			# end
		else
			flash.now[:danger] = "There was something wrong with your login information"
			render 'new'
		end
	end

	def loginVerifyOtp
		if  current_user.authenticate_otp(params[:user][:otp], drift: 120)
			current_user.update(active_session_exists: true)
			flash[:success] = "You have successfully logged in"
			redirect_to user_path(current_user)
		else
			current_user = nil
			session[:user_id] = nil
			flash[:danger] = "Invalid OTP, Please retry loging in"
			redirect_to root_path
		end
	end

	def destroy
		user = User.find_by(id: session[:user_id])
		user.update(active_session_exists: false)
		session[:user_id] = nil
		flash[:success] = "You have logged out"
		redirect_to root_path
	end

	private 

	def no_login
		if logged_in?
			flash[:danger]="You are already logged in!"
			redirect_to user_path(current_user)
		end
	end

end