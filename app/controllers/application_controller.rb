class ApplicationController < ActionController::Base
  include SessionsHelper
  protect_from_forgery prepend: true
  #protect_from_forgery with: :exception
end

#This is base class of all the controllers
