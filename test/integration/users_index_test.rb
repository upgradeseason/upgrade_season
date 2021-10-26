require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:danelli)
    @non_admin = users(:brucelee)
    #Pulls the users out of users.yml
  end

  test "index as admin including pagination and delete links" do
    #It's protected page, so log in.
    log_in_as(@admin)
    #what should it do? Visit index path >
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.first.toggle!(:activated)
    #^What does this do?
    get users_path
    #It should render index page, verify first page of users is present
    assert_template 'users/index'
    #Make sure pagination is basically working
    #Check for a div with class Pagination
    assert_select 'div.pagination'
    #assert_select 'div.pagination'.count == 2 #My first failed attempt at this syntax
    assert_select 'div.pagination', count: 2
    #Test for each user there's link to profile page
    #user_path of user
    assigns(:users).each do |user|
      #assert user.activated?
      #^Test that user is activated? needs to be implemented
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
