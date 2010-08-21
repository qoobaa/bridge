require "helper"

class TestDeal < Test::Unit::TestCase
  test "first deal conversion" do
    id = 0
    deal = Bridge::Deal.from_id(id)
    assert deal.valid?
    assert_equal %w(SA SK SQ SJ ST S9 S8 S7 S6 S5 S4 S3 S2).map { |c| Bridge::Card.new(c) }, deal.n
    assert_equal %w(HA HK HQ HJ HT H9 H8 H7 H6 H5 H4 H3 H2).map { |c| Bridge::Card.new(c) }, deal.e
    assert_equal %w(DA DK DQ DJ DT D9 D8 D7 D6 D5 D4 D3 D2).map { |c| Bridge::Card.new(c) }, deal.s
    assert_equal %w(CA CK CQ CJ CT C9 C8 C7 C6 C5 C4 C3 C2).map { |c| Bridge::Card.new(c) }, deal.w
    assert_equal id, deal.id
  end

  test "first deal hcp" do
    deal = Bridge::Deal.from_id(0)
    assert_equal 10, deal.hcp("N")
    assert_equal 10, deal.hcp("E")
    assert_equal 10, deal.hcp("S")
    assert_equal 10, deal.hcp("W")
    assert_equal 20, deal.hcp("NS")
    assert_equal 20, deal.hcp("EW")
  end

  test "last deal conversion" do
    id = Bridge::DEALS - 1
    deal = Bridge::Deal.from_id(id)
    assert deal.valid?
    assert_equal %w(CA CK CQ CJ CT C9 C8 C7 C6 C5 C4 C3 C2).map { |c| Bridge::Card.new(c) }, deal.n
    assert_equal %w(DA DK DQ DJ DT D9 D8 D7 D6 D5 D4 D3 D2).map { |c| Bridge::Card.new(c) }, deal.e
    assert_equal %w(HA HK HQ HJ HT H9 H8 H7 H6 H5 H4 H3 H2).map { |c| Bridge::Card.new(c) }, deal.s
    assert_equal %w(SA SK SQ SJ ST S9 S8 S7 S6 S5 S4 S3 S2).map { |c| Bridge::Card.new(c) }, deal.w
    assert_equal id, deal.id
  end

  test "last deal hcp" do
    deal = Bridge::Deal.from_id(Bridge::DEALS - 1)
    assert_equal 10, deal.hcp("N")
    assert_equal 10, deal.hcp("E")
    assert_equal 10, deal.hcp("S")
    assert_equal 10, deal.hcp("W")
    assert_equal 20, deal.hcp("NS")
    assert_equal 20, deal.hcp("EW")
  end

  test "deal no 1 000 000 000 000" do
    id = 1_000_000_000_000
    deal = Bridge::Deal.from_id(id)
    assert deal.valid?
    assert_equal id, deal.id
  end

  test "sample deal to id conversion" do
    deal = Bridge::Deal.new("N" => %w(SA SK SQ SJ HA HK HQ DA DK DQ CA CK CQ),
                            "E" => %w(ST S9 S8 S7 S6 S5 S4 S3 S2 HJ HT H9 H8),
                            "S" => %w(H7 H6 H5 H4 H3 H2 DJ DT D9 D8 D7 D6 D5),
                            "W" => %w(D4 D3 D2 CJ CT C9 C8 C7 C6 C5 C4 C3 C2))
    assert deal.valid?
    id = deal.id
    assert_equal deal, Bridge::Deal.from_id(id)
  end

  test "deal with doubled cards is not valid deal" do
    deal = Bridge::Deal.new("N" => %w(SA SA SQ SJ HA HK HQ DA DK DQ CA CK CQ),
                            "E" => %w(ST S9 S8 S7 S6 S5 S4 S3 S2 HJ HT H9 H8),
                            "S" => %w(H7 H6 H5 H4 H3 H2 DJ DT D9 D8 D7 D6 D5),
                            "W" => %w(D4 D3 D2 CJ CT C9 C8 C7 C6 C5 C4 C3 C2))
    assert_false deal.valid?
  end

  test "deal with different length hands is not valid deal" do
    deal = Bridge::Deal.new("N" => %w(SA SK SQ SJ HA HK HQ DA DK DQ CA CK CQ ST),
                            "E" => %w(S9 S8 S7 S6 S5 S4 S3 S2 HJ HT H9 H8),
                            "S" => %w(H7 H6 H5 H4 H3 H2 DJ DT D9 D8 D7 D6 D5),
                            "W" => %w(D4 D3 D2 CJ CT C9 C8 C7 C6 C5 C4 C3 C2))
    assert_false deal.valid?
  end

  test "random deal id is valid deal id" do
    id = Bridge::Deal.random_id
    assert Bridge.deal_id?(id)
  end

  test "random deal is valid deal" do
    deal = Bridge::Deal.random
    assert deal.valid?
  end

  test "comparison of two deals" do
    deal1 = Bridge::Deal.from_id(1_000_000_000_000_000)
    deal2 = Bridge::Deal.from_id(9_000_000_000_000_000)
    assert deal1 < deal2
  end

  test "fetching wrong direction raises an error" do
    deal = Bridge::Deal.random
    assert_raises(ArgumentError) do
      deal[:h]
    end
  end

  test "passing incorrect id to from_id raises an error" do
    assert_raises(ArgumentError) do
      Bridge::Deal.from_id(-1)
    end
  end

  test "owner returns correct direction" do
    deal = Bridge::Deal.new({ "N" => ["SK", "S9", "S7", "S6", "S4", "S2", "HA", "HJ", "H2", "D7", "D2", "C6", "C3"],
                              "E" => ["SA", "SJ", "ST", "H3", "DA", "DK", "DT", "D9", "D8", "D5", "D4", "CK", "CJ"],
                              "S" => ["S8", "S5", "S3", "HK", "HQ", "HT", "H8", "H4", "DQ", "D3", "CQ", "C4", "C2"],
                              "W" => ["SQ", "H9", "H7", "H6", "H5", "DJ", "D6", "CA", "CT", "C9", "C8", "C7", "C5"] })

    assert_equal "N", deal.owner("SK")
    assert_equal "N", deal.owner("C3")
    assert_equal "E", deal.owner("SJ")
    assert_equal "E", deal.owner("CK")
    assert_equal "S", deal.owner("S3")
    assert_equal "S", deal.owner("CQ")
    assert_equal "W", deal.owner("H6")
    assert_equal "W", deal.owner("C9")
  end

  test "to_hash returns hash" do
    deal = Bridge::Deal.from_id(0)
    assert_equal Hash, deal.to_hash.class
  end

  test "to_hash returns hash with arrays of strings" do
    deal = Bridge::Deal.from_id(0)
    assert_equal String, deal.to_hash["N"].first.class
  end
end

class TestDealSort < Test::Unit::TestCase
  def setup
    @deal = Bridge::Deal.new({ "N" => ["SK", "S9", "S7", "S6", "S4", "HA", "HJ", "H3", "H2", "D7", "D2", "C6", "C3"],
                              "E" => ["SA", "SQ", "SJ", "ST", "S2", "DA", "DK", "DT", "D9", "D8", "D5", "CK", "CJ"],
                              "S" => ["S8", "S5", "S3", "HK", "HQ", "HT", "H8", "H4", "DQ", "D3", "CQ", "C4", "C2"],
                              "W" => ["H9", "H7", "H6", "H5", "DJ", "D6", "D4", "CA", "CT", "C9", "C8", "C7", "C5"] })
  end

  test "split cards by color for given direction" do
    expected = { "S" => @deal.n.select { |c| c.suit == "S" },
                 "H" => @deal.n.select { |c| c.suit == "H" },
                 "D" => @deal.n.select { |c| c.suit == "D" },
                 "C" => @deal.n.select { |c| c.suit == "C" } }
    assert_equal expected, @deal.cards_for("N")
  end

  test "return colors as key only if cards are present on hand" do
    expected = { "S" => @deal.e.select { |c| c.suit == "S" },
                 "H" => [],
                 "D" => @deal.e.select { |c| c.suit == "D" },
                 "C" => @deal.e.select { |c| c.suit == "C" } }
    assert_equal expected, @deal.cards_for("E")
  end

  test "return sorted 4 colors" do
    assert_equal ["S", "H", "C", "D"], @deal.send(:sort_colors, ["S", "H", "D", "C"])
    assert_equal ["S", "H", "C", "D"], @deal.send(:sort_colors, ["H", "D", "S", "C"])
    assert_equal ["S", "H", "C", "D"], @deal.send(:sort_colors, ["D", "S", "C", "H"])
  end

  test "return sorted 3 colors" do
    assert_equal ["S", "H", "C"], @deal.send(:sort_colors, ["S", "H", "C"])
    assert_equal ["H", "C", "D"], @deal.send(:sort_colors, ["H", "D", "C"])
    assert_equal ["H", "S", "D"], @deal.send(:sort_colors, ["S", "H", "D"])
    assert_equal ["S", "D", "C"], @deal.send(:sort_colors, ["S", "D", "C"])
  end

  test "return sorted 2 colors" do
    assert_equal ["S", "H"], @deal.send(:sort_colors, ["S", "H"])
    assert_equal ["S", "D"], @deal.send(:sort_colors, ["S", "D"])
    assert_equal ["C", "D"], @deal.send(:sort_colors, ["D", "C"])
    # assert_equal ["H", "C"], @deal.sort_colors(["H", "C"])
  end

  test "return sorted 4 colors with trump" do
    assert_equal ["S", "H", "C", "D"], @deal.send(:sort_colors, ["S", "H", "D", "C"], "S")
    assert_equal ["H", "S", "D", "C"], @deal.send(:sort_colors, ["H", "D", "S", "C"], "H")
    assert_equal ["D", "S", "H", "C"], @deal.send(:sort_colors, ["D", "S", "C", "H"], "D")
    assert_equal ["C", "H", "S", "D"], @deal.send(:sort_colors, ["D", "S", "C", "H"], "C")
  end

  test "return sorted 3 colors with trump" do
    assert_equal ["S", "H", "C"], @deal.send(:sort_colors, ["S", "H", "C"], "S")
    assert_equal ["H", "S", "C"], @deal.send(:sort_colors, ["S", "H", "C"], "H")
    assert_equal ["S", "H", "D"], @deal.send(:sort_colors, ["S", "H", "D"], "S")
    assert_equal ["D", "S", "H"], @deal.send(:sort_colors, ["S", "H", "D"], "D")
  end

  test "return sorted 2 colors with trump" do
    assert_equal ["S", "H"], @deal.send(:sort_colors, ["S", "H"], "S")
    assert_equal ["H", "S"], @deal.send(:sort_colors, ["S", "H"], "H")
    assert_equal ["C", "S"], @deal.send(:sort_colors, ["S", "C"], "C")
    assert_equal ["D", "H"], @deal.send(:sort_colors, ["H", "D"], "D")
  end

  test "sort hands by colors" do
    expected =  {
      "N" => ["SK", "S9", "S7", "S6", "S4", "HA", "HJ", "H3", "H2", "C6", "C3", "D7", "D2"],
      "E" => ["SA", "SQ", "SJ", "ST", "S2", "DA", "DK", "DT", "D9", "D8", "D5", "CK", "CJ"],
      "S" => ["S8", "S5", "S3", "HK", "HQ", "HT", "H8", "H4", "CQ", "C4", "C2", "DQ", "D3"],
      "W" => ["H9", "H7", "H6", "H5", "CA", "CT", "C9", "C8", "C7", "C5", "DJ", "D6", "D4"]
    }
    assert_equal expected, @deal.sort_by_color!.to_hash
  end

  test "sort hands by colors with trump" do
    expected = {
      "N" => ["C6", "C3", "HA", "HJ", "H3", "H2", "SK", "S9", "S7", "S6", "S4", "D7", "D2"],
      "E" => ["CK", "CJ", "DA", "DK", "DT", "D9", "D8", "D5", "SA", "SQ", "SJ", "ST", "S2"],
      "S" => ["CQ", "C4", "C2", "HK", "HQ", "HT", "H8", "H4", "S8", "S5", "S3", "DQ", "D3"],
      "W" => ["CA", "CT", "C9", "C8", "C7", "C5", "H9", "H7", "H6", "H5", "DJ", "D6", "D4"]
    }
    assert_equal expected, @deal.sort_by_color!("C").to_hash
  end

  test "not modify hands if sorted by color without !" do
    old_deal = @deal.to_hash
    @deal.sort_by_color
    assert_equal old_deal, @deal.to_hash
  end
end
