module SessionsHelper

  #Logs in given user.
  def log_in(user)
    session[:user_id] = user.id #We placed the user ID into the (temporary) session (to retreive it on subsequent pages)
  #session is a special method, we treat it like a hash, give it a key [:user_id]
  #session (helper) creates a special kind of cookie, a temporary cookie. "persistence"
  #user_id is encrypted (temp encrypted cookie placed on browser, next page unencrypts it
  #session method safely encrypts user_id, encrypted version visible in browser console
  end

  def current_user #Method to return that user (the current logged-in user, if any).
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
      #@current_user = @current_user, but if this is nil(false) then 2nd part's evaluated/executed>>^
      #This helper allows us to find the current user in the DB and do things like change site layout based on
      #existence of that user
    end
  end

  #Returns true if (current user in session is NOT nil, aka if user is logged in, false otherwise.
  def logged_in? #Helper method is boolean so => logged_in? (with a question mark)
    !current_user.nil? #ivars are nil if not been defined
  end

  def log_out
    reset_session #prevent session fixation/attack vector, ensure all session variables are reset upon logout
    @current_user = nil
    #Put log_out method to use in sessions_controller destory action.
  end
end
