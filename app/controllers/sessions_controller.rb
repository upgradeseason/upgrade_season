class SessionsController < ApplicationController

  def new
  end

  def create #inside the create action, params hash has the info needed to authenticate users by email & password
    #Create new session by finding user, if this is true, we log user in, redirect to show/user profile page
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      reset_session #prevent session fixation attack vector, ensure all session variables are reset upon logout
      log_in user #log_in method used, related to sessions, put in module(helper)
      #log_in (sessions_helper.rb) is a layer of abstraction, bc this could get more complicated over time, and we'll
      #use this in a couple of different places
      #Log user in and redirect to the user's Show page
      redirect_to user #Rails auto-converts user to the route of the user profile page aka #user_url(user)
    else
    flash.now[:danger] = 'Invalid email/password combination!'
    render 'new'
    end

  end

  def destroy #This is the sessions_controller destroy action
  log_out
  redirect_to root_url #Homepage, redirects dont use root_path
  end
end
