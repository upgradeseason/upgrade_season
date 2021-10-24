class UsersController < ApplicationController

  #Invoke logged_in_user method before given methods
  #Give it the name (it's a symbol) of the before_filter
  #Give it array of actions we want to protect with the before filter (symbols)
  #Meaning we restrict it to only act on EDIT and UPDATE actions.
  #So we pass the appropriate =>  only: [:options1, :options2] hash
  #@user variable is made accessible due to edit and update actions being filtered
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def index
    @users = User.all
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
    #@user = User.find(params[:id])
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

  private #Private is only used internally, here by the users_controller, and not exposed to external users via web

    def user_params
    #Strong parameters
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
end
