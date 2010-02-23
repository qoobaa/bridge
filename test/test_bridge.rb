require "helper"

class TestBridge < Test::Unit::TestCase
  test "negative number is not valid deal id" do
    assert_false Bridge.deal_id?(-1)
  end

  test "number of possible bridge deals is not valid deal id" do
    assert_false Bridge.deal_id?(Bridge::DEALS)
  end
end
