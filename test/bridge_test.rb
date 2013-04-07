require "helper"

describe Bridge do
  it "negative number is not valid deal id" do
    refute Bridge.deal_id?(-1)
  end

  it "number of possible bridge deals is not valid deal id" do
    refute Bridge.deal_id?(Bridge::DEALS)
  end

  it "return partner of direction" do
    assert_equal "N", Bridge.partner_of("S")
    assert_equal "S", Bridge.partner_of("N")
    assert_equal "E", Bridge.partner_of("W")
    assert_equal "W", Bridge.partner_of("E")
  end

  it "return side of direction" do
    assert_equal "NS", Bridge.side_of("S")
    assert_equal "NS", Bridge.side_of("N")
    assert_equal "EW", Bridge.side_of("W")
    assert_equal "EW", Bridge.side_of("E")
  end

  it "return next direction" do
    assert_equal "E", Bridge.next_direction("N")
    assert_equal "S", Bridge.next_direction("E")
    assert_equal "W", Bridge.next_direction("S")
    assert_equal "N", Bridge.next_direction("W")
    assert_equal "N", Bridge.next_direction(nil)
  end

  it "return vulnerable for given deal nr" do
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

  describe "bid regexp" do
    it "matches 1S" do
      assert_equal "1S", "1SS".match(Bridge::BID_REGEXP)[:bid]
    end

    it "matches 7NT" do
      assert_equal "7NT", "7NTE".match(Bridge::BID_REGEXP)[:bid]
    end

    it "does not match 8NT" do
      assert_nil "8NTE".match(Bridge::BID_REGEXP)
    end
  end

  describe "modifier regexp" do
    it "matches X" do
      assert_equal "X", "1SXS".match(Bridge::MODIFIER_REGEXP)[:modifier]
    end

    it "matches XX" do
      assert_equal "XX", "1NTXXS".match(Bridge::MODIFIER_REGEXP)[:modifier]
    end
  end

  describe "result regexp" do
    it "matches =" do
      assert_equal "=", "1SNXE=".match(Bridge::RESULT_REGEXP)[:result]
    end

    it "matches -12" do
      assert_equal "-12", "12NTNXE-12".match(Bridge::RESULT_REGEXP)[:result]
    end
  end

  describe "contract regexp" do
    it "matches 1SN" do
      assert_equal "1SXN", "1SXN-2".match(Bridge::CONTRACT_REGEXP)[:contract]
    end

    it "matches 7NTXXS" do
      assert_equal "7NTXXS", "7NTXXS=".match(Bridge::CONTRACT_REGEXP)[:contract]
    end
  end

  describe "score regexp" do
    it "matches 7NTXXS-2" do
      matched = "7NTXXS-2".match(Bridge::SCORE_REGEXP)
      assert_equal "7NTXXS-2", matched[:score]
      assert_equal "7NTXXS", matched[:contract]
      assert_equal "7NT", matched[:bid]
      assert_equal "XX", matched[:modifier]
      assert_equal "S", matched[:direction]
      assert_equal "-2", matched[:result]
    end
  end
end
