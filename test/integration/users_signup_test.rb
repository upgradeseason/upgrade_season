require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path # We visit the named path.
    # Simulate going to signup page to catch bad mistakes, major regressions, aka verify it renders without error.
    # We issue a POST request to users_path (the same way submit button does) so the signup_path isn't necessary.
    assert_no_difference 'User.count' do #  User.count is a string argument to #assert_no_difference method.
      # We're counting bc we're creating a user.
      # The count method is avail on every ActiveRecord class.
      post users_path, params: { user: { name:  "foobar",
      # POST request to users_path
      # params[:user] hash is expected by the User.new create action.
      # We're simulating form submission here.
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" }}
    end
  assert_template 'users/new' # Test that it re-renders new template from users controller.

  # Use assert_select to test HTML elements of the unlikely-to-change pages
  # The hash symbol in CSS targets a single specific element with a unique ID, the CSS ID for error_explanation.
  assert_select 'div#error_explanation'
  # The CSS dot "." symbol targets multiple elements within a class, after the dot is the class for field with error
  assert_select 'div.field_with_errors'
  assert_select 'div.alert'
  end

  #Test successful submission that actually creates a new user
  test "valid signup information with account activation" do
    get signup_path
    #assert THAT difference
    assert_difference 'User.count', 1 do #1 specifies size of difference
      post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    #follow_redirect!
    #Check email deliverd, check array set during test
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user) #Assigns lets us access ivars in the corresponding actin
    #^Looks for corresponding ivar, pulls user out, and assigns to local var
    assert_not user.activated?
    #Try to login before activating
    log_in_as(user)
    assert_not is_logged_in?
    #Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    #Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    #Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show' #Means routes, show action, and show.html.erb work
    assert is_logged_in?
    assert_not flash.empty?
  end
end
