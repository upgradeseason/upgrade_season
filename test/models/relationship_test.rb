require "test_helper"

class RelationshipTest < ActiveSupport::TestCase
# Add some validations to the relationship model, start w/ some tests.

def setup
  @relationship = Relationship.new(follower_id: users(:danelli).id,
                                   followed_id: users(:brucelee).id)
end

#Do our usual sanity check
  test "should be valid" do
    assert @relationship.valid?
  end

# Presence validations
  test "should require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "should require a followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end


end
