class UsersController < ApplicationController

  #Invoke logged_in_user method before given methods
  #Give it the name (it's a symbol) of the before_filter
  #Give it array of actions we want to protect with the before filter (symbols)
  #Meaning we restrict it to only act on EDIT and UPDATE actions.
  #So we pass the appropriate =>  only: [:options1, :options2] hash
  #@user variable is made accessible due to edit and update actions being filtered
  #Require users be logged in to delete etc
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    #will_paginate gem does magic, amazing things, auto adds paginate method to every ActiveRecord object.
    #Replaced User.all with object that knows about pagination
    #Bc its users controller, will_paginate knows to paginate ivar @users
    @users = User.paginate(page: params[:page])
  end

  def show
    #Params used to retreive user ID, same as #User.find(1)
    @user = User.find(params[:id])
    #debugger #remove comment to enable
  end

  #New action to Users controller
  def new
    @user = User.new
    #debugger
  end

  def create
    @user = User.new(user_params)
    if @user.save
      #We needed the user on the form, so we needed an instance variable
      #handle success
      reset_session
      log_in @user #Add a call to log_in (in Users cotroller, create action, to log users in after signup
      #^Can comment out to see if test works
      flash[:success] = 'Welcome to Upgrade Season!' #hash-like object, value is 'Welc..'
      #flash tells Rails to only persist for 1 request, actually uses cookie.
      redirect_to @user
      #redirect_to user's profile page, eg users/1
    else
      render 'new' #Renders new template
    end
  end

  def edit
    #Requres a logged in user.
    #@user = User.find(params[:id]) #Commented out due to filter finding user
    #debugger
  end

  def update
    #Also requires a logged in user.
    #@user = User.find(params[:id])
    if @user.update(user_params)
      #Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url #the users index
  end

  private #Private is only used internally, here by the users_controller, and not exposed to external users via web

    def user_params
    #Strong parameters => require and permit
    #Prevents attacker using curl to send patch request to make /users/17?admin=1
    #Write test to make sure admin attribute is not permitted attribute
    #It’s a good idea to write a test for any attribute that isn’t editable
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    #Before filters

    #Confirms a logged in user
    def logged_in_user
      unless logged_in?
        #debugger
        store_location #Created this method in the sessions helper
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    #Confirms the correct user (and defines @user variable so we can delete our user var assignments in edit/update
    def correct_user
      @user = User.find(params[:id])
      #Make sure @user is same as current user
      redirect_to(root_url) unless current_user?(@user) #helper used instead of #unless @user == current_user
      #This boolean is more expressive
    end

    #Confirms an admin user
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
