# This is the base class of all controllers
class ApplicationController < ActionController::Base
  include SessionsHelper #We include this module so it's available in our controllers
  # protect_from_forgery prepend: true
  # protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  # Confirms a logged in user
  def logged_in_user
    unless logged_in?
      #debugger
      store_location #Created this method in the sessions helper
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
end
