require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:danelli)
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
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user #check right redirect target
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0 
    #verify login link disappears by verify 0 login paths appear
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path #reappearance
    assert_select "a[href=?]", logout_path,       count: 0 #dissappearance
    assert_select "a[href=?]", user_path(@user),  count: 0 #dissappearance
  end
end
