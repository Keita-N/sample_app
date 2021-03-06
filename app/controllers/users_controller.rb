class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

	def show
		@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
	end
	
	def new
		@user = User.new
	end

	def create
    @user = User.new(params[:user])
    if @user.save
      @user.send_activate_account
      redirect_to root_path, notice:"Access to the URL in an activation mail."
    else
      render 'new'
    end
  end

  def update
    @user.attributes = params[:user]
    if @user.save(context: :registration)
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def edit
  end

  def destroy
    user = User.find(params[:id])
    if user.admin?
      redirect_to root_path if user.admin?
    else
      user.destroy
      flash[:success] = "User destroyed"
      redirect_to users_url
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page:params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def activate
    @user = User.find_by_remember_token(params[:id])
    if @user
      @user.change_state!
      # @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user # サインインさせたらダメ？？？
    else
      redirect_to root_path
    end
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end
end
