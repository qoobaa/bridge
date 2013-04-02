require "helper"

describe Bridge::Bid do
  it "pas is not a valid bid" do
    assert_raises(ArgumentError) do
      Bridge::Bid.new("pas")
    end
  end

  it "case doesn't matter in bid" do
    assert_equal "PASS", Bridge::Bid.new("pass").to_s
    assert_equal "X", Bridge::Bid.new("x").to_s
    assert_equal "XX", Bridge::Bid.new("xx").to_s
    assert_equal "1NT", Bridge::Bid.new("1nt").to_s
  end

  it "pass is a valid bid" do
    bid = Bridge::Bid.new("PASS")
    assert bid.pass?
    refute bid.double?
    refute bid.redouble?
    refute bid.modifier?
    refute bid.contract?
    assert_nil bid.level
    assert_nil bid.suit
  end

  it "double is a valid bid" do
    bid = Bridge::Bid.new("X")
    refute bid.pass?
    assert bid.double?
    refute bid.redouble?
    assert bid.modifier?
    refute bid.contract?
    assert_nil bid.level
    assert_nil bid.suit
  end

  it "redouble is a valid bid" do
    bid = Bridge::Bid.new("XX")
    refute bid.pass?
    refute bid.double?
    assert bid.redouble?
    assert bid.modifier?
    refute bid.contract?
    assert_nil bid.level
    assert_nil bid.suit
  end

  it "1H is a valid bid" do
    bid = Bridge::Bid.new("1H")
    refute bid.pass?
    refute bid.double?
    refute bid.redouble?
    refute bid.modifier?
    assert bid.contract?
    assert_equal "1", bid.level
    assert_equal "H", bid.suit
  end

  it "7NT is a valid bid" do
    bid = Bridge::Bid.new("7NT")
    refute bid.pass?
    refute bid.double?
    refute bid.redouble?
    refute bid.modifier?
    assert bid.contract?
    assert_equal "7", bid.level
    assert_equal "NT", bid.suit
  end

  it "7NT is greater than 1C" do
    assert Bridge::Bid.new("7NT") > Bridge::Bid.new("1C")
    refute Bridge::Bid.new("7NT") < Bridge::Bid.new("1C")
    refute Bridge::Bid.new("7NT") == Bridge::Bid.new("1C")
  end

  it "1S is greater than 1H" do
    assert Bridge::Bid.new("1S") > Bridge::Bid.new("1H")
    refute Bridge::Bid.new("1S") < Bridge::Bid.new("1H")
    refute Bridge::Bid.new("1S") == Bridge::Bid.new("1H")
  end

  it "comparison of PASS and 1S raises an error" do
    assert_raises(ArgumentError) do
      Bridge::Bid.new("PASS") > Bridge::Bid.new("1S")
    end
  end

  it "comparison of X and PASS raises an error" do
    assert_raises(ArgumentError) do
      Bridge::Bid.new("X") > Bridge::Bid.new("PASS")
    end
  end

  it "PASS and XX are not equal" do
    refute_equal Bridge::Bid.new("PASS"), Bridge::Bid.new("XX")
  end

  it "1S returns S trump" do
    assert_equal "S", Bridge::Bid.new("1S").trump
  end

  it "5NT returns nil trump" do
    assert_nil Bridge::Bid.new("5NT").trump
  end

  it "1H is a major bid" do
    assert Bridge::Bid.new("1H").major?
  end

  it "5S is a major bid" do
    assert Bridge::Bid.new("5S").major?
  end

  it "2C is a minor bid" do
    assert Bridge::Bid.new("2C").minor?
  end

  it "6D is a minor bid" do
    assert Bridge::Bid.new("6D").minor?
  end

  it "1NT is a nt bid" do
    assert Bridge::Bid.new("1NT").nt?
  end

  it "6NT is a small slam" do
    assert Bridge::Bid.new("6NT").small_slam?
  end

  it "7NT is a grand slam" do
    assert Bridge::Bid.new("7NT").grand_slam?
  end
end
