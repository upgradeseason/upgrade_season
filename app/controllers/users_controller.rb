class UsersController < ApplicationController

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
      #handle success
      reset_session
      log_in @user
      flash[:success] = 'Welcome to Upgrade Season!' #hash-like object, value is 'Welc..'
      #flash tells Rails to only persist for 1 request, actually uses cookie.
      redirect_to @user
      #redirect_to user's profile page, eg users/1
    else
      render 'new' #Renders new template
    end
  end

  private #Private is only used internally, here by the users_controller, and not exposed to external users via web

    def user_params
    #Strong parameters
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
