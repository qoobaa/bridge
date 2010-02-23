require "helper"

class TestDeal < Test::Unit::TestCase
  test "first deal conversion" do
    id = 0
    deal = Bridge::Deal.from_id(id)
    assert deal.valid?
    assert_equal %w(SA SK SQ SJ ST S9 S8 S7 S6 S5 S4 S3 S2), deal.n
    assert_equal %w(HA HK HQ HJ HT H9 H8 H7 H6 H5 H4 H3 H2), deal.e
    assert_equal %w(DA DK DQ DJ DT D9 D8 D7 D6 D5 D4 D3 D2), deal.s
    assert_equal %w(CA CK CQ CJ CT C9 C8 C7 C6 C5 C4 C3 C2), deal.w
    assert_equal id, deal.id
  end

  test "last deal conversion" do
    id = Bridge::DEALS - 1
    deal = Bridge::Deal.from_id(id)
    assert deal.valid?
    assert_equal %w(CA CK CQ CJ CT C9 C8 C7 C6 C5 C4 C3 C2), deal.n
    assert_equal %w(DA DK DQ DJ DT D9 D8 D7 D6 D5 D4 D3 D2), deal.e
    assert_equal %w(HA HK HQ HJ HT H9 H8 H7 H6 H5 H4 H3 H2), deal.s
    assert_equal %w(SA SK SQ SJ ST S9 S8 S7 S6 S5 S4 S3 S2), deal.w
    assert_equal id, deal.id
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
end
