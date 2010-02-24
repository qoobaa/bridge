require "helper"

class TestBid < Test::Unit::TestCase
  test "pas is not a valid bid" do
    assert_raises(ArgumentError) do
      Bridge::Bid.new("pas")
    end
  end

  test "case doesn't matter in bid" do
    Bridge::Bid.new("pass")
    Bridge::Bid.new("x")
    Bridge::Bid.new("xx")
    Bridge::Bid.new("1nt")
  end

  test "pass is a valid bid" do
    bid = Bridge::Bid.new("PASS")
    assert bid.pass?
    assert_false bid.double?
    assert_false bid.redouble?
    assert_false bid.modifier?
    assert_false bid.contract?
    assert_nil bid.level
    assert_nil bid.suit
  end

  test "double is a valid bid" do
    bid = Bridge::Bid.new("X")
    assert_false bid.pass?
    assert bid.double?
    assert_false bid.redouble?
    assert bid.modifier?
    assert_false bid.contract?
    assert_nil bid.level
    assert_nil bid.suit
  end

  test "redouble is a valid bid" do
    bid = Bridge::Bid.new("XX")
    assert_false bid.pass?
    assert_false bid.double?
    assert bid.redouble?
    assert bid.modifier?
    assert_false bid.contract?
    assert_nil bid.level
    assert_nil bid.suit
  end

  test "1H is a valid bid" do
    bid = Bridge::Bid.new("1H")
    assert_false bid.pass?
    assert_false bid.double?
    assert_false bid.redouble?
    assert_false bid.modifier?
    assert bid.contract?
    assert_equal "1", bid.level
    assert_equal "H", bid.suit
  end

  test "7NT is a valid bid" do
    bid = Bridge::Bid.new("7NT")
    assert_false bid.pass?
    assert_false bid.double?
    assert_false bid.redouble?
    assert_false bid.modifier?
    assert bid.contract?
    assert_equal "7", bid.level
    assert_equal "NT", bid.suit
  end

  test "7NT is greater than 1C" do
    assert Bridge::Bid.new("7NT") > Bridge::Bid.new("1C")
    assert_false Bridge::Bid.new("7NT") < Bridge::Bid.new("1C")
    assert_false Bridge::Bid.new("7NT") == Bridge::Bid.new("1C")
  end

  test "1S is greater than 1H" do
    assert Bridge::Bid.new("1S") > Bridge::Bid.new("1H")
    assert_false Bridge::Bid.new("1S") < Bridge::Bid.new("1H")
    assert_false Bridge::Bid.new("1S") == Bridge::Bid.new("1H")
  end

  test "initialize works using shortcut" do
    Bid("pass")
  end

  test "comparison of PASS and 1S raises an error" do
    assert_raises(ArgumentError) do
      Bridge::Bid.new("PASS") > Bridge::Bid.new("1S")
    end
  end

  test "comparison of X and PASS raises an error" do
    assert_raises(ArgumentError) do
      Bridge::Bid.new("X") > Bridge::Bid.new("PASS")
    end
  end

  test "PASS and XX are not equal" do
    assert_not_equal Bridge::Bid.new("PASS"), Bridge::Bid.new("XX")
  end
end
