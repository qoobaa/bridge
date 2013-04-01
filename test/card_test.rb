require "helper"

describe Bridge::Card do
  it "H2 is a valid card" do
    card = Bridge::Card.new("H2")
    assert "H", card.suit
    assert "2", card.value
  end

  it "ST is a valid card" do
    card = Bridge::Card.new("ST")
    assert "S", card.suit
    assert "T", card.value
  end

  it "CQ is a valid card" do
    card = Bridge::Card.new("CQ")
    assert "C", card.suit
    assert "Q", card.value
  end

  it "NT1 is not a valid card" do
    assert_raises(ArgumentError) do
      Bridge::Card.new("NT1")
    end
  end

  it "1H is not a valid card" do
    assert_raises(ArgumentError) do
      Bridge::Card.new("1H")
    end
  end

  it "ST is lower than SJ" do
    assert Bridge::Card.new("ST") < Bridge::Card.new("SJ")
  end

  it "H2 has no hcp" do
    assert_equal 0, Bridge::Card.new("H2").hcp
  end

  it "SJ has 1 hcp" do
    assert_equal 1, Bridge::Card.new("SJ").hcp
  end

  it "CQ has 2 hcp" do
    assert_equal 2, Bridge::Card.new("CQ").hcp
  end

  it "CK has 3 hcp" do
    assert_equal 3, Bridge::Card.new("CK").hcp
  end

  it "DA has 4 hcp" do
    assert_equal 4, Bridge::Card.new("DA").hcp
  end
end
