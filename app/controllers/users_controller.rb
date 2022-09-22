class UsersController < ApplicationController

	before_action :require_user, except: [:new, :create]

	def index
		@users = User.paginate(page: params[:page], per_page: 6)
	end

	def new
		@user = User.new
	end

	def create
		if params[:user][:password]!=params[:user][:conf_password] #Check if passwords match
			flash[:danger] = "Passwords don't match"
			redirect_to signup_path
		else
			@user = User.new(user_params)
			if @user.save
				session[:user_id] = @user.id
				otp = @user.otp_code
				if Rails.env == 'development' || Rails.env == 'test'
					UserMailer.send_otp_email(@user, otp).deliver_now
					#remove after deployment
					response = OtpSms.send_otp(otp, @user.phone)
					puts "responseeeeeeeeeeeeee  #{response}  eeeeeeeeeeeeeeeeee"

					if response["return"]
						flash[:success] = response["message"][0]
					else
					 	@user.destroy
						@user = nil
						flash[:danger] = "Sending OTP failed, Please retry signing up"
						redirect_to root_path
					end
				else
					response = OtpSms.send_otp(otp, @user.phone)
					if response["return"]
						flash[:success] = response["message"][0]
					else
					 	@user.destroy
						@user = nil
						flash[:danger] = "Sending OTP failed, Please retry signing up"
						redirect_to root_path
					end
				end
				render 'verifyOtp'
			else
				render 'new'
			end
		end
	end

	def verifyOtp
		if  current_user.authenticate_otp(params[:user][:otp])
			flash[:success] = "Welcome to the quiz app, #{current_user.username}"
			redirect_to user_path(current_user)
		else
			current_user.destroy
			current_user = nil
			flash[:danger] = "Invalid OTP, Please retry signing up"
			redirect_to root_path
		end
	end

	def edit
		@user = User.find(params[:id])
		if current_user!=@user
			flash[:danger]="You can only edit your own account"
			redirect_to root_path
		end
	end

	def update
		@user = User.find(params[:id])
		if current_user!=@user
			flash[:danger]="You can only edit your own account"
			redirect_to root_path
		end
		if params[:password].blank?
			params.delete(:password)
		end
		if @user.update(user_params)
			flash[:success] = "Your account was updated successfully"
			redirect_to quizzes_path
		else
			render 'edit'
		end
	end

	def show
		@user = User.find(params[:id])
		if @user.admin? && !current_user.admin?
			redirect_to users_path
		end
		@quizzes = Quiz.where(id: Submission.select(:quiz_id).where(user_id: @user.id))
		@submissions = Submission.where(user_id: @user.id)
    @submitted_quizzes = Quiz.joins(:submissions).where(id: @submissions.pluck(:quiz_id))
	end

	def editPassword
	end

	def updatePassword
		user_pwd_change = current_user
		if params[:user][:old_password].blank? || params[:user][:new_password].blank? || params[:user][:conf_password].blank?
	      flash[:danger] = "Enter all fields"
	      redirect_to editPassword_path
	    else
			if params[:user][:new_password]!=params[:user][:conf_password] #Check if passwords match
				flash[:danger] = "Passwords don't match"
				redirect_to editPassword_path
			elsif params[:user][:old_password]==params[:user][:new_password] #Check if new password is same as old password
				flash[:danger] = "New password cannot be same as old password"
				redirect_to editPassword_path
			elsif user_pwd_change.authenticate(params[:user][:old_password]) #Check if old password is correct
				user_pwd_change.password=params[:user][:new_password]
				if user_pwd_change.save
					flash[:success] = "Password was changed successfully"
					redirect_to user_path(user_pwd_change)
				else
					flash[:danger] = "Password cannot be blank"
					redirect_to editPassword_path
				end
			else
				flash[:danger] = "Wrong old password"
				redirect_to editPassword_path
			end
		end
	end

	def destroy
		@user = User.find(params[:id])
		if !current_user.admin? && current_user!=@user #Only admins and user of the account can delete
			flash[:danger]="You can only delete your own account"
			redirect_to users_path
		elsif
			@user.destroy
			flash[:danger] = "User and all submissions by user have been deleted"
			redirect_to users_path
		end
	end

	private

	def user_params
		params.require(:user).permit(:username, :email, :password, :phone, :otp)
	end


end