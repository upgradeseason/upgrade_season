require "test_helper"

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:danelli)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    assert_select'input[name=?]', 'password_reset[email]'
    #Invalid email
    post password_resets_path, params: { password_reset: { email: "" }}
    assert_not flash.empty?
    assert_template 'password_resets/new'
    #Valid email
    post password_resets_path,
      params: { password_reset: { email: @user.email }}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    #Password reset form
    #Pull user out with #assigns
    user = assigns(:user)
    #Wrong email
    #reset_token is part of attr_accessor, set only when digests gets set, it's a virtual attribute
    get edit_password_reset_path(user.reset_token, email: '')
    assert_redirected_to root_url
    #Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    #Right email, wrong token
    #Something else that could go wrong
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    #Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    #Rarely test HTML structure, only stuff that's unlikely to break
    #Assert presence of input tag w/ right name, type, and value
    #Can put a bunch of different attributes in here
    assert_select "input[name=email][type=hidden][value=?]", user.email
    #Once we get to that form, we want to submit it, check to see what happens in that case.
    #Table shows PATCH request to password_reset_path
    patch password_reset_path(user.reset_token),
      params: { email: user.email,
                user: { password:      "foobaz",
                password_confirmation: "barquuz" } }
    #What should this do? We want it to render errors, we can looks for div with ID error_explanation
    assert_select 'div#error_explanation'
    #Check blank password, tricky case.
    patch password_reset_path(user.reset_token),
        params: { email: user.email,
                  user: { password:      "  ",
                  password_confirmation: "foobar" } }
    assert_not flash.empty?
    #assert_select 'div#error_explanation'
    assert_template 'password_resets/edit'
    #Last thing, what happens if u put in valid pw/confirmation?
    patch password_reset_path(user.reset_token),
        params: { email: user.email,
          user: { password:              "foobaz",
                  password_confirmation: "foobaz" } }
    #And what should happen? Look controller
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
    #assert_nil user.reload.reset_digest
    assert_nil assigns(:user).reset_digest
  end

  test "expired_token" do
    get new_password_reset_path
    post password_resets_path,
      params: { password_reset: { email: @user.email}}
    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token),
      params: { email: @user.email,
        user: {passwoord:   "foobar",
               password_confirmation: "foobar"}}
    assert_response :redirect
    follow_redirect!
    #assert_match /expired/i, response.body
    assert_match 'expired', response.body
  end
end
