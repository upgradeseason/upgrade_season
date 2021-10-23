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
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template'users/edit'
    patch user_path(@user), params: { user: { name:  "foobar",
    #PATCH request to users_path
    #params[:user] hash is expected by the User update action.
    #We're simulating form submission here.
                                              email: "user@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" }}
    #Test right template is rendered
    assert_template 'users/edit'
    #assert_select 'div/alert', text: "The form contains 4 errors."
    #Fix this div alert test

  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    #Chewing direct patch request
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
  assert_not flash.empty? #Dont need to test actual key
  assert_redirected_to @user #Redirect to profile page
  @user.reload #Reload the user’s values from the database and confirm that they were successfully updated
  assert_equal @user.name, "Foo Bar" #Check user info was changed in DB
  assert_equal @user.email, "foo@bar.com"
  end
end
