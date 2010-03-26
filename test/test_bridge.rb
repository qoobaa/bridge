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

  test "return vulnerable for given deal nr" do
    assert_equal "NONE", Bridge.vulnerable_in_deal(nil)

    assert_equal "NONE", Bridge.vulnerable_in_deal(1)
    assert_equal "NS", Bridge.vulnerable_in_deal(2)
    assert_equal "EW", Bridge.vulnerable_in_deal(3)
    assert_equal "BOTH", Bridge.vulnerable_in_deal(4)

    assert_equal "NS", Bridge.vulnerable_in_deal(5)
    assert_equal "EW", Bridge.vulnerable_in_deal(6)
    assert_equal "BOTH", Bridge.vulnerable_in_deal(7)
    assert_equal "NONE", Bridge.vulnerable_in_deal(8)

    assert_equal "EW", Bridge.vulnerable_in_deal(9)
    assert_equal "BOTH", Bridge.vulnerable_in_deal(10)
    assert_equal "NONE", Bridge.vulnerable_in_deal(11)
    assert_equal "NS", Bridge.vulnerable_in_deal(12)

    assert_equal "BOTH", Bridge.vulnerable_in_deal(13)
    assert_equal "NONE", Bridge.vulnerable_in_deal(14)
    assert_equal "NS", Bridge.vulnerable_in_deal(15)
    assert_equal "EW", Bridge.vulnerable_in_deal(16)

    assert_equal "NONE", Bridge.vulnerable_in_deal(17)
    assert_equal "NS", Bridge.vulnerable_in_deal(18)
    assert_equal "EW", Bridge.vulnerable_in_deal(19)
    assert_equal "BOTH", Bridge.vulnerable_in_deal(20)
  end
end
