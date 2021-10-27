require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:danelli)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@upgradeseason.com"], mail.from
    assert_match user.name,               mail.body.encoded
    #Add activation_token to the fixture user
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
    #RegExp match => make sure 'Hi' appears in encodded version of mail
    #assert_match "Hi", mail.body.encoded
  end

  test "password_reset" do
    user = users(:danelli)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Password reset", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@upgradeseason.com"], mail.from
    #Add_reset_token to the fixture user
    assert_match user.reset_token,   mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
    #RegExp match => make sure 'xyz' appears in encoded version of mail
    #assert_match "xyz", mail.body.encoded
  end
end
