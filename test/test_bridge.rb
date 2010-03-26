require "helper"

class TestBridge < Test::Unit::TestCase
  test "negative number is not valid deal id" do
    assert_false Bridge.deal_id?(-1)
  end

  test "number of possible bridge deals is not valid deal id" do
    assert_false Bridge.deal_id?(Bridge::DEALS)
  end

  test "return partner of direction" do
    assert_equal "N", Bridge.partner_of("S")
    assert_equal "S", Bridge.partner_of("N")
    assert_equal "E", Bridge.partner_of("W")
    assert_equal "W", Bridge.partner_of("E")
  end

  test "return side of direction" do
    assert_equal "NS", Bridge.side_of("S")
    assert_equal "NS", Bridge.side_of("N")
    assert_equal "EW", Bridge.side_of("W")
    assert_equal "EW", Bridge.side_of("E")
  end

  test "return next direction" do
    assert_equal "E", Bridge.next_direction("N")
    assert_equal "S", Bridge.next_direction("E")
    assert_equal "W", Bridge.next_direction("S")
    assert_equal "N", Bridge.next_direction("W")
    assert_equal "N", Bridge.next_direction(nil)
  end

  test "return next vulnerable" do
    assert_equal "NONE", Bridge.next_vulnerable("BOTH")
    assert_equal "NS", Bridge.next_vulnerable("NONE")
    assert_equal "EW", Bridge.next_vulnerable("NS")
    assert_equal "BOTH", Bridge.next_vulnerable("EW")
    assert_equal "NONE", Bridge.next_vulnerable(nil)
  end
end
