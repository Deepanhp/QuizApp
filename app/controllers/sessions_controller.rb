class SessionsController < ApplicationController
	#Deals with authentication
	before_action :require_user, only: [:destroy]
	before_action :no_login, except: [:destroy]
	def new
		 
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			# if !user.active_session_exists
				session[:user_id] = user.id
				user.update(active_session_exists: true)
				flash[:success] = "You have successfully logged in"
				redirect_to user_path(user)
			# else
			# 	flash[:success] = "You have active login session"
			# 	redirect_to root_path
			# end
		else
			flash.now[:danger] = "There was something wrong with your login information"
			render 'new'
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