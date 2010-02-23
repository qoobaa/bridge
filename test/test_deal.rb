require "helper"

class TestBridge < Test::Unit::TestCase
  test "first deal conversion" do
    id = 0
    deal = Bridge::Deal.id_to_deal(id)
    assert Bridge::Deal.deal?(deal)
    assert_equal %w(SA SK SQ SJ ST S9 S8 S7 S6 S5 S4 S3 S2), deal["N"]
    assert_equal %w(HA HK HQ HJ HT H9 H8 H7 H6 H5 H4 H3 H2), deal["E"]
    assert_equal %w(DA DK DQ DJ DT D9 D8 D7 D6 D5 D4 D3 D2), deal["S"]
    assert_equal %w(CA CK CQ CJ CT C9 C8 C7 C6 C5 C4 C3 C2), deal["W"]
    assert_equal id, Bridge::Deal.deal_to_id(deal)
  end

  test "last deal conversion" do
    id = Bridge::DEALS - 1
    deal = Bridge::Deal.id_to_deal(id)
    assert Bridge::Deal.deal?(deal)
    assert_equal %w(CA CK CQ CJ CT C9 C8 C7 C6 C5 C4 C3 C2), deal["N"]
    assert_equal %w(DA DK DQ DJ DT D9 D8 D7 D6 D5 D4 D3 D2), deal["E"]
    assert_equal %w(HA HK HQ HJ HT H9 H8 H7 H6 H5 H4 H3 H2), deal["S"]
    assert_equal %w(SA SK SQ SJ ST S9 S8 S7 S6 S5 S4 S3 S2), deal["W"]
    assert_equal id, Bridge::Deal.deal_to_id(deal)
  end

  test "deal no 1 000 000 000" do
    id = 1_000_000_000
    deal = Bridge::Deal.id_to_deal(id)
    assert Bridge::Deal.deal?(deal)
    assert_equal id, Bridge::Deal.deal_to_id(deal)
  end

  test "sample deal to id conversion" do
    deal = {
      "N" => %w(SA SK SQ SJ HA HK HQ DA DK DQ CA CK CQ),
      "E" => %w(ST S9 S8 S7 S6 S5 S4 S3 S2 HJ HT H9 H8),
      "S" => %w(H7 H6 H5 H4 H3 H2 DJ DT D9 D8 D7 D6 D5),
      "W" => %w(D4 D3 D2 CJ CT C9 C8 C7 C6 C5 C4 C3 C2)
    }
    assert Bridge::Deal.deal?(deal)
    id = Bridge::Deal.deal_to_id(deal)
    assert_equal deal, Bridge::Deal.id_to_deal(id)
  end

  test "deal with doubled cards is not valid deal" do
    deal = {
      "N" => %w(SA SA SQ SJ HA HK HQ DA DK DQ CA CK CQ),
      "E" => %w(ST S9 S8 S7 S6 S5 S4 S3 S2 HJ HT H9 H8),
      "S" => %w(H7 H6 H5 H4 H3 H2 DJ DT D9 D8 D7 D6 D5),
      "W" => %w(D4 D3 D2 CJ CT C9 C8 C7 C6 C5 C4 C3 C2)
    }
    assert_false Bridge::Deal.deal?(deal)
  end

  test "deal with different length hands is not valid deal" do
    deal = {
      "N" => %w(SA SK SQ SJ HA HK HQ DA DK DQ CA CK CQ ST),
      "E" => %w(S9 S8 S7 S6 S5 S4 S3 S2 HJ HT H9 H8),
      "S" => %w(H7 H6 H5 H4 H3 H2 DJ DT D9 D8 D7 D6 D5),
      "W" => %w(D4 D3 D2 CJ CT C9 C8 C7 C6 C5 C4 C3 C2)
    }
    assert_false Bridge::Deal.deal?(deal)
  end

  test "negative number is not valid deal id" do
    assert_false Bridge::Deal.deal_id?(-1)
  end

  test "number of possible bridge deals is not valid deal id" do
    assert_false Bridge::Deal.deal_id?(Bridge::DEALS)
  end

  test "random deal id is valid deal id" do
    id = Bridge::Deal.random_deal_id
    assert Bridge::Deal.deal_id?(id)
  end

  test "random deal is valid deal" do
    deal = Bridge::Deal.random_deal
    assert Bridge::Deal.deal?(deal)
  end
end
