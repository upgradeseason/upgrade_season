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
      flash[:success] = 'Welcome to Upgrade Season!'
      redirect_to @user
      #redirect_to user_url(@user) => Alternative code
    else
      render 'new' #Renders new template
    end
  end

  private #Private is only used internally, here by users controller and exposed to external users via the web

    def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
