class UsersController < ApplicationController

  def show
    #Params used to retreive user ID, same as #User.find(1)
    @user = User.find(params[:id])
    #debugger
  end

  #New action to Users controller
  def new
    @user = User.new
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
      render 'new'
    end
  end

  private

    def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
