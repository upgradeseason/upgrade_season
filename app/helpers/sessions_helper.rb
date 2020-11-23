module SessionsHelper

  #Logs in given user.
  def log_in(user)
    session[:user_id] = user.id #Place user ID in temporary session (to retreive it on subsequent pages)
  end

  def current_user #Returns current logged-in user (if any).
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  #Returns true if user is logged in, false otherwise.
  def logged_in?
    !@current_user.nil?
    #!current_user.nil?
  end

  def log_out
    reset_session
    @current_user = nil
  end
end
