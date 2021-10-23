require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:danelli)
    #Pulls the user out of users.yml
  end

  test "login with valid email, invalid password" do
    get login_path
    assert_template 'sessions/new'
    #Key is session> (Params hash)
    post login_path, params: { session: { email: @user.email, password: "invalid" } }
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email, #POST email belonging to user
                                          password: 'password' } } #All users in test DB will have pw of 'password'
    assert is_logged_in?
    assert_redirected_to @user #Check its the right redirect target
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in? #(Sessions) Helper methods aren’t available in tests, so we use test_helper.rb
    #^We define test specific method is_logged_in?
    assert_select "a[href=?]", login_path, count: 0  #Assert there's no such link
    #Verify login link disappears by verifying 0 login path links appear on that page
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user) #profile link
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    #Simulate a user clicking logout in a 2nd window
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path #reappearance
    assert_select "a[href=?]", logout_path,       count: 0 #dissappearance
    assert_select "a[href=?]", user_path(@user),  count: 0 #dissappearance
  end

  test "login with remembering" do
    #Alternate inverse/negated/identical version
    #log_in_as(@user, remember_me: '0')
    #assert_nil cookies['remember_token'] #Cookies of string remember token works, not symbol
    #To Do: Check that cookie remember_token is == to the user's remember_token
    log_in_as(@user, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
                       #[:remember_token]
    #assert_equal @user, assigns(:user).@user
  end

  test "login without remembering" do
    #Log in to set the cookie
    log_in_as(@user, remember_me: '1')
    #Log in again and verify cookie is gone
    log_in_as(@user, remember_me: '0')
    assert_empty cookies[:remember_token]
  end
end
