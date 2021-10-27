# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    #Wrong no. of args given, account_activation requires we give it parameter of user
    #UserMailer.account_activation
    user = User.first
    #Activation token is virtual attribute, we must give development db user one
    #valid user object required as arg >
    #Acct activation templates require user.activation_token (user from db dont have one)
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end
end
