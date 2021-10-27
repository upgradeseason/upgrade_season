class AccountActivationsController < ApplicationController

  #Matches session controller to log users in.
  def edit
    user = User.find_by(email: params[:email])
    #Authenticate according to email address in params hash from key value pair in URL
    #The params ID passed to authenticated? is the actual token
    #Only executes if user not activated.
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      #Activate the user, update activated attribute to be true, update activated_at timestamp to be current time.
      #Better to put this on user model, not EDIT action
      #user.update_attribute(:activated,    true)
      #user.update_attribute(:activated_at, Time.zone.now)
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user #profile page
      #Basically put what was in users controller here^
    else
      #Handle invalid link
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
      #Write integrated test for this^
    end
  end

  #Account activation link will be routed to EDIT action
  #write the edit action in the Account Activations controller that actually activates the user
end
