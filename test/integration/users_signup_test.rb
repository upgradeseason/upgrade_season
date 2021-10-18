require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "invalid signup information" do
    get signup_path #We have a named path, we visit it. 
    #Simulate going to signup page to catch bad mistakes/major regressions, aka verify renders w/o error.
    #However we do issue POST request to users_path(the way submit button does) so signup_path isn't necessary.
    assert_no_difference 'User.count' do #User.count is a string argument to #assert_no_difference method. 
      #The count method is avail on every ActiveRecord class.
      post users_path, params: { user: { name:  "",
      #POST request to users_path
      #params[:user] hash is expected by the User.new create action.
      #We're simulating form submission here.
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" }}
    end
  assert_template 'users/new' #Test it re-renders new template from users controller.

  #Use assert_select to test HTML elements of the unlikely-to-change pages
  assert_select 'div#error_explanation'
  #The hash symbol in CSS targets a single specific element with unique ID, the CSS ID for error_explanation.
  assert_select 'div.field_with_errors'
  #The CSS dot "." symbol targest multiple elements within a class, after the dot is the class for field with error
  assert_select 'div.alert'

  end

  #Test successful submission that actually creates a new user
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do #1 specifies size of difference
      post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show' #Means routes, show action, and show.html.erb work
    assert is_logged_in?
    assert_not flash.empty?
  end
end
