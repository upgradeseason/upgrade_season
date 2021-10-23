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
end
