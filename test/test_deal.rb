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
