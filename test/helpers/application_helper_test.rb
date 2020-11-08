require 'test_helper'

class AppliationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,          'Upgrade Season'
    assert_equal full_title("Help"),  'Help | Upgrade Season'
  end
end
