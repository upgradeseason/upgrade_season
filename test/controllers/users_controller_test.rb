require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user       = users(:danelli)
    @other_user = users(:brucelee)
  end

 test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect index when not logged in" do
    get users_path                  # users_path is the INDEX action's named route
    assert_redirected_to login_url  # Redirect logged out users to login_url
  end
  # Emphasize how we're handling the access to each of these (user controller) actions.
  # We want to issue a GET request to the EDIT action and issue a PATCH request to UPDATE action.
  # And verify if user is logged in they get redirected to the login URL.
  # ^aka lets test the redirection for the EDIT and UPDATE actions.

  test "should redirect edit when not logged in" do
    # Here we're dealing with just the actions
    # We use the named route, we do a GET with the edit_user_path
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    # Here we're dealing with just the actions
    # We use the named route?
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email }}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    # Controller tests, we use lower level @user instead of route/helper re: URLs
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect udpate when logged in as wrong user" do
    log_in_as(@other_user)
    # Controller tests, we use lower level @user instead of route/helper re: URLs
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email }}
    # patch :update, id: @user user: { name: @user.name, email: @user.email }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should not allow assigning user admin role" do
    log_in_as(@other_user)
    assert_not @other_user.admin? # Verify user is currently not admin
    patch user_path(@other_user), params: { user: { name: @other_user.name, email: @other_user.email, admin: true }}
    assert_not @other_user.reload.admin? #  Reload, pull user from DB, then recheck if admin, to conclude the test.
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do #  Invalid info shouldn't change user account.
      # Issue delete request to destroy action (using named route)
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
      end
    assert_redirected_to root_url
  end

  test "should redirect following when not logged in" do
    # get :following, id: @user #deprecated syntax
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end
