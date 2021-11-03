class UsersController < ApplicationController

  # Invoke logged_in_user method before given methods
  # Give it the name (it's a symbol) of the before_filter
  # Give it array of actions we want to protect with the before filter (symbols)
  # Meaning we restrict it to only act on EDIT and UPDATE actions.
  # So we pass the appropriate =>  only: [:options1, :options2] hash
  # @user variable is made accessible due to edit and update actions being filtered
  # Require users be logged in to delete etc
  # Actions protected by the logged_in_user before filter
  # Before filters

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    # will_paginate gem does magic, amazing things, auto adds paginate method to every ActiveRecord object.
    # Replaced User.all with object that knows about pagination
    # Bc its users controller, will_paginate knows to paginate ivar @users
    @users = User.paginate(page: params[:page])
    # Show only activated users, need to do
    # @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    # Params used to retreive user ID, same as #User.find(1)
    @user = User.find(params[:id])
    # Go through the @user.microposts association
    # @microposts var used in show.html.erb
    @microposts = @user.microposts.paginate(page: params[:page])
    # debugger #remove comment to enable
    # redirect_to root_url and return unless true
    redirect_to root_url and return unless @user.activated?
  end

  # New action to Users controller
  def new
    @user = User.new
    # debugger
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # We needed the user on the form, so we needed an instance variable
      # handle success
      # reset_session
      @user.send_activation_email
      # UserMailer.account_activation(@user).deliver_now #Better to attach to user model, nice lil abstraction layer
      # log_in @user #Add a call to log_in (in Users cotroller, create action, to log users in after signup
      # ^Can comment out to see if test works
      flash[:info] = 'Please check your email to activate your account' #hash-like object, value is 'Welc..'
      # flash tells Rails to only persist for 1 request, actually uses cookie.
      # redirect_to @user
      # redirect_to user's profile page, eg users/1
      redirect_to root_url
    else
      render 'new' #Renders new template
    end
  end

  def edit
    # Requres a logged in user.
    # @user = User.find(params[:id]) #Commented out due to filter finding user
    # debugger
  end

  def update
    # Also requires a logged in user.
    # @user = User.find(params[:id])
    if @user.update(user_params)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url # The users index
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private # Private is only used internally, here by the users_controller, and not exposed to external users via web

    def user_params
    # Strong parameters => require and permit
    # Prevents attacker using curl to send patch request to make /users/17?admin=1
    # Write test to make sure admin attribute is not permitted attribute
    # It’s a good idea to write a test for any attribute that isn’t editable
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Confirms the correct user (and defines @user variable so we can delete our user var assignments in edit/update
    def correct_user
      @user = User.find(params[:id])
      # Make sure @user is same as current user
      redirect_to(root_url) unless current_user?(@user) #helper used instead of #unless @user == current_user
      # This boolean is more expressive
    end

    # Confirms an admin user
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
