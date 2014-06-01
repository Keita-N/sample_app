class PasswordResetsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by_email(params[:email])
  	user.send_password_reset if user
  	redirect_to root_path, notice:"Email sent with password reset instruction."
  end

  def edit
  	@user = User.find_by_password_reset_token(params[:id])
  end

  def update
  	@user = User.find_by_password_reset_token!(params[:id])
  	if @user.password_reset_sent_at < 2.hours.ago
      flash[:error] = "Password &crarr; reset has expired."
  		redirect_to new_password_reset_path
      # , alert:"Password &crarr; reset has expired."
  	elsif @user.update_attributes(params[:user])
  		flash[:notice] = "Password has been reset."
  		# redirect_to root_url, notice:"Password has been reset."
  		sign_in @user
			# redirect_back_or(user)
			redirect_to @user
  	else
  		render "edit"
  	end
  			
  end
end
