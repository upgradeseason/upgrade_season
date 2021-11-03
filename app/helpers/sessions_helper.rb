module SessionsHelper

  # Logs in given user.
  def log_in(user)
    session[:user_id] = user.id #We placed the user ID into the (temporary) session (to retreive it on subsequent pages)
    # session is a special method, we treat it like a hash, give it a key [:user_id]
    # session (helper) creates a special kind of cookie, a temporary cookie. "persistence"
    # user_id is encrypted (temp encrypted cookie placed on browser, next page unencrypts it
    # session method safely encrypts user_id, encrypted version visible in browser console
  end

  # Remembers new user in a persistent session
  # Endows user with remember_token
  def remember(user)
    # This will involve calling that user.remember method
    user.remember
    # set the cookies (set user_id) #Place the 2 cookies on the browser
    # > Takes a hash
    # cookies[:user_id] = { value = user.id,
                          #expires = 20.years.from_now.utc } #Same thing, common Rails convetion>
    # Creates encrypted permanent cookie, corresp to user id, we decrypt on next browser request
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns true if the (argument) given user matches the current user.
  def current_user?(user)
    # user == current_user
    user && user == current_user #Catch edge case where user is nil
  end

  # Complicated logic, good idea to test drive, TDD
  # Only finds by id, need to modify to find by session if user logged out
  def current_user #Method to return that user (the current logged-in user, if any).
    # In order to not access the session twice, create local var
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
      # @current_user = @current_user, but if this is nil(false) then 2nd part's evaluated/executed>>^
      # This helper allows us to find the current user in the DB and do things like change site layout based on
      # existence of that user
    # This branch corresponds to user visiting site after having closed the browser
    elsif (user_id = cookies.signed[:user_id]) 
      # branch hits if current_user is nil and session remembered
      # Raise #This branch was untested before.
      # Raise an exception in the suspected untested block of code: if the code isn’t covered, the tests will pass
      # If it is covered, the resulting error will identify the relevant test
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user # Ruby returns last statemnt evaluated, so user here.
      end
    end
  end

  # Returns true if (current user in session is NOT nil, aka if user is logged in, false otherwise.
  def logged_in? #  Helper method is boolean so => logged_in? (with a question mark)
    !current_user.nil? #  ivars are nil if not been defined
  end

  # Forgets a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id) #  cookies method has a delete method just like session
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    # session.delete(:user_id)
    reset_session # Prevent session fixation/attack vector, ensure all session variables are reset upon logout
    @current_user = nil
    # Put log_out method to use in sessions_controller destory action.
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Stores the URL trying to be accessed.
  def store_location
    # Use the request object to get the forwarding URL
    # URL is put into the session variable under the :forwarding_url key
    # Only for GET requests
    session[:forwarding_url] = request.original_url if request.get?
  end
end
