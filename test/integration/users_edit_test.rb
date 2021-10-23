require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:danelli)
    #Pulls the user out of users.yml
  end


  test "invalid edit" do
    get edit_user_path(@user)
    patch user_path(@user), params: { user: { name:  "foobar",
      #PATCH request to users_path
      #params[:user] hash is expected by the User.new create action.
      #We're simulating form submission here.
                                              email: "user@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" }}
    #Test right template is rendered
    assert_template 'users/edit'
    #assert_select 'div/alert', text: "The form contains 4 errors."
  end

  test "valid edit" do
    get edit_user_path(@user)
    patch user_path(@user), params: { user: { name: "Foo Bar",
                                              email: "foo@bar.com",
                                              password:              "",
                                              password_confirmation: "" } }
  assert_not flash.empty? #Dont need to test actual key
  assert_redirected_to @user
  @user.reload
  assert_equal @user.name, "Foo Bar"
  assert_equal @user.email, "foo@bar.com"
  end
end
