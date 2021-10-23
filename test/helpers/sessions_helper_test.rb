require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  #Reset current user's remember_token and verify that @current_user returns nil
  #Re: sessions_helper.rb current_user branch
  def setup
    @user = users(:danelli) #Pull a user out of fixtures
    remember(@user) #Calling remember here which sets the cookie
  end

  test "current_user returns right user when session is nil" do
    #assert equal actual, expected
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "current_user returns nil when rememeber digest is wrong" do
    #Want authenticated method to return false
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end
