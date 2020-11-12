require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "invalid signup information" do
    get signup_path #Visit signup path to doublecheck signup form renders without error
    #Issue post request to users_path (by using the post function)
    assert_no_difference 'User.count' do #User.count is a string argument to #assert_no_diff... method
      post users_path, params: { user: { name:  "", #params[:user] hash is expected by the User.new create action.
                                        email: "user@invalid",
                                        password:              "foo",
                                        password_confirmation: "bar" }}
    end
  assert_template 'users/new'
  assert_select 'div#error_explanation'# hash in CSS targets a single specific element with unique ID
  assert_select 'div.field_with_errors'#. (the period or dot) targest MULTIPLE elements within a class
  #assert_select 'div id="error_explanation"' My wrong syntax attempt at testing error messages of
  #CSS id for error explanation and CSS class for field with error

  end
  #^^^before_count = User.count
  #post users_path, ...
  #after_count  = User.count
  #assert_equal before_count, after_count

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
assert_not flash.empty? #can delete this line? I think not
  end
end
