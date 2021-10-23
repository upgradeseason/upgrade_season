ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!


class ActiveSupport::TestCase
  #For model test
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  #Returns true if a test user is logged in
  def is_logged_in?
    !session[:user_id].nil?
  end

  #Manipulate the session directly
  #Log in as a particular user
  #Parallel log_in_as helpers
  def log_in_as(user)
    session[:user_id] = user.id
  end
  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest

  #Log in as particular user
  #Integration test is same as controller test here in terms of the class
  #We can use code from controller test in integration test, w/o changing the method
  def log_in_as(user, password: 'password', remember_me: '1') 
    #password and remember_me are keywork args, defaults accepted of 'password' and '1'
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  #When we post the logout path through the form there's the ^remember me checkbox
  end
end
