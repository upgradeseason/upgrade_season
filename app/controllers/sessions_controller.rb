class SessionsController < ApplicationController

  def new
  end

  def create #inside the create action, params hash has the info needed to authenticate users by email & password
    #Create new session by finding user, if this is true, we log user in, redirect to show/user profile page
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      reset_session #prevent session fixation
      log_in user #log_in method used, related to sessions, put in module(helper)
      #Log user in and redirect to the user's Show page
      redirect_to user #converted to route of the user profile page #user_url(user)
    else
    flash.now[:danger] = 'Invalid email/password combination!'
    render 'new'
    end

  end

  def destroy
  log_out
  redirect_to root_url
  end
end
