class PasswordResetsController < ApplicationController
  before_action :get_user,         only: [:edit, :update]
  before_action :valid_user,       only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]


  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
#We make it @user to use the #assigns user trick to be able to do a test for this.
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email #anticipate this lil abstraction
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found" #Render just regular flash
      render 'new'
    end
  end

  def edit
  end

  def update
    if password_blank?
      flash.now[:danger] = "Password can't be blank"
      render 'edit'
    elsif @user.update(user_params)
      #^When this is invalid (false) b/c user attempts to change PW incorrectly (EG bad pw), we render edit form.
      #forget(@user) #My first attempt, bad syntax
      #@user.forget
      #reset_session
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    #Strong parameters => require and permit
    #Prevents attacker using curl to send patch? request to make /users/17?admin=1?
    #Write test to make sure admin attribute is not permitted attribute?
    #It’s a good idea to write a test for any attribute that isn’t editable
    params.require(:user).permit(:password, :password_confirmation)
  end

  #Returns true if password is blank.
  def password_blank?
    params[:user][:password].blank? #&&
    #params[:user][:password_confirmation].blank?
  end

  #Before filters

  def get_user
    @user = User.find_by(email: params[:email])
    #Belongs in filter> refactor it out
    #unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
      #redirect_to root_url
    #end
  end

  #Confirms a valid user
  def valid_user
    unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end

  #Checks expiration of reset token
  def check_expiration
    if @user.password_reset_expired?
      #Write test to check this case.
      flash[:danger] = "Password reset has expired"
      redirect_to new_password_reset_url
    end
  end
end
