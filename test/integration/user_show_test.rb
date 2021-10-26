require "test_helper"

class UserShowTest < ActionDispatch::IntegrationTest

  def setup
    @inactive_user  = users(:inactive)
    @activated_user = users(:danelli)
  end

  test "should redirect when user not activated" do
    get user_path(@inactive_user)
#    assert_response      flash[:warning] = "Account not activated yet"
    assert_redirected_to root_url
  end

  test "should display user when activated" do
    get user_path(@activated_user)
#    assert_response flash[:success] = "Account activated!"
#    assert_template user/show
  end
end
