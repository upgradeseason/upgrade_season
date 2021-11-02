# This is where people log in

class SessionsController < ApplicationController

  def new
    #debugger
  end

  # Handle case where user isn't activated
  # Intricate logic
  def create #inside the create action, params hash has the info needed to authenticate users by email & password
    #Create new session by finding user(by something unique), if this is true, we log user in, redirect to show/user profile page
    @user = User.find_by(email: params[:session][:email].downcase)
    #If user exists, then we authenticate the user by the password, authenticate does the comparision of pw for us
    if @user&.authenticate(params[:session][:password])
      if @user.activated?
        forwarding_url = session[:forwarding_url]
        reset_session #prevent session fixation attack vector, ensure all session variables are reset upon logout
        #Ternary operator makes if/else/end statement one line here
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        #() needed ^ bc Ruby doesn't know how to parse this line without them here
        #remember helper, not same as user model's remember method
        log_in @user #log_in method used, related to sessions, put in module(helper)
        #log_in (sessions_helper.rb) is a layer of abstraction, bc this could get more complicated over time, and we'll
        #use this in a couple of different places
        #Log user in and redirect to the user's Show page
        redirect_to forwarding_url || @user #Rails auto-converts user to the route of the user profile page aka #user_url(user)
      else
        message  = "Your account has not been activated yet. "
        message += "Please check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination!'
      render 'new'
    end

  end

  def destroy #This is the sessions_controller destroy action
  log_out if logged_in?
  redirect_to root_url #Homepage, redirects dont use root_path
  end
end
