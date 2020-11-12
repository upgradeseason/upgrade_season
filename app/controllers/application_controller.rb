class ApplicationController < ActionController::Base
  include SessionsHelper
  protect_from_forgery prepend: true
end
