class ApplicationController < ActionController::Base
  include SessionsHelper
  #protect_from_forgery prepend: true
  #protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
end

#This is base class of all the controllers
