require 'helper'

class TestBridge < Test::Unit::TestCase
  test "first deal conversion" do
    id = 0
    deal = Bridge.id_to_deal(id)
    assert Bridge.deal?(deal)
    assert_equal %w(AS KS QS JS TS 9S 8S 7S 6S 5S 4S 3S 2S), deal[:n]
    assert_equal %w(AH KH QH JH TH 9H 8H 7H 6H 5H 4H 3H 2H), deal[:e]
    assert_equal %w(AD KD QD JD TD 9D 8D 7D 6D 5D 4D 3D 2D), deal[:s]
    assert_equal %w(AC KC QC JC TC 9C 8C 7C 6C 5C 4C 3C 2C), deal[:w]
    assert_equal id, Bridge.deal_to_id(deal)
  end

  test "last deal conversion" do
    id = Bridge::DEALS - 1
    deal = Bridge.id_to_deal(id)
    assert Bridge.deal?(deal)
    assert_equal %w(AC KC QC JC TC 9C 8C 7C 6C 5C 4C 3C 2C), deal[:n]
    assert_equal %w(AD KD QD JD TD 9D 8D 7D 6D 5D 4D 3D 2D), deal[:e]
    assert_equal %w(AH KH QH JH TH 9H 8H 7H 6H 5H 4H 3H 2H), deal[:s]
    assert_equal %w(AS KS QS JS TS 9S 8S 7S 6S 5S 4S 3S 2S), deal[:w]
    assert_equal id, Bridge.deal_to_id(deal)
  end

  test "deal no 1 000 000 000" do
    id = 1_000_000_000
    deal = Bridge.id_to_deal(id)
    assert Bridge.deal?(deal)
    assert_equal id, Bridge.deal_to_id(deal)
  end

  test "sample deal to id conversion" do
    deal = {
      :n => %w(AS KS QS JS AH KH QH AD KD QD AC KC QC),
      :e => %w(TS 9S 8S 7S 6S 5S 4S 3S 2S JH TH 9H 8H),
      :s => %w(7H 6H 5H 4H 3H 2H JD TD 9D 8D 7D 6D 5D),
      :w => %w(4D 3D 2D JC TC 9C 8C 7C 6C 5C 4C 3C 2C)
    }
    assert Bridge.deal?(deal)
    id = Bridge.deal_to_id(deal)
    assert_equal deal, Bridge.id_to_deal(id)
  end

  test "deal with doubled cards is not valid deal" do
    deal = {
      :n => %w(AS AS QS JS AH KH QH AD KD QD AC KC QC),
      :e => %w(TS 9S 8S 7S 6S 5S 4S 3S 2S JH TH 9H 8H),
      :s => %w(7H 6H 5H 4H 3H 2H JD TD 9D 8D 7D 6D 5D),
      :w => %w(4D 3D 2D JC TC 9C 8C 7C 6C 5C 4C 3C 2C)
    }
    assert_false Bridge.deal?(deal)
  end

  test "deal with different length hands is not valid deal" do
    deal = {
      :n => %w(AS KS QS JS AH KH QH AD KD QD AC KC QC TS),
      :e => %w(9S 8S 7S 6S 5S 4S 3S 2S JH TH 9H 8H),
      :s => %w(7H 6H 5H 4H 3H 2H JD TD 9D 8D 7D 6D 5D),
      :w => %w(4D 3D 2D JC TC 9C 8C 7C 6C 5C 4C 3C 2C)
    }
    assert_false Bridge.deal?(deal)
  end

  test "negative number is not valid deal id" do
    assert_false Bridge.deal_id?(-1)
  end

  test "number of possible bridge deals is not valid deal id" do
    assert_false Bridge.deal_id?(Bridge::DEALS)
  end

  test "random deal id is valid deal id" do
    id = Bridge.random_deal_id
    assert Bridge.deal_id?(id)
  end

  test "random deal is valid deal" do
    deal = Bridge.random_deal
    assert Bridge.deal?(deal)
  end
end
