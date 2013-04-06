require "helper"

describe Bridge::Play do
  it "returns deal from deal_id" do
    play = Bridge::Play.new(0, "7SN", [])
    assert_equal Bridge::Deal, play.deal.class
  end

  it "returns player positions" do
    play = Bridge::Play.new(0, "7SS", [])
    assert_equal "S", play.declarer
    assert_equal "W", play.lho
    assert_equal "N", play.dummy
    assert_equal "E", play.rho
  end

  it "returns trump" do
    play = Bridge::Play.new(0, "7SN", [])
    assert_equal "S", play.trump

    play = Bridge::Play.new(0, "7NTN", [])
    assert_nil play.trump
  end

  it "returns tricks" do
    play = Bridge::Play.new(0, "7SN", ["HA", "D2", "C2", "S2", "SA"])
    assert_equal ["HA", "D2", "C2", "S2"], play.tricks.first.cards.map(&:to_s)
    assert_equal ["SA"], play.tricks.last.cards.map(&:to_s)
  end

  it "returns directions of played cards" do
    play = Bridge::Play.new(0, "7SN", ["HA", "D2", "C2", "S2", "SA"])
    assert_equal ["E", "S", "W", "N", "N"], play.directions
  end

  describe "#next_direction" do
    it "returns direction next to dealer if first lead" do
      play = Bridge::Play.new(0, "7SN", [])
      assert_equal "E", play.next_direction
    end

    it "returns direction of last trick winner when lead" do
      play = Bridge::Play.new(0, "7SN", ["HA", "D2", "C2", "S2"])
      assert_equal "N", play.next_direction
    end

    it "returns direction next to previous if trick not complete" do
      play = Bridge::Play.new(0, "7SN", ["HA", "D2", "C2"])
      assert_equal "N", play.next_direction
    end

    it "returns last trick winner on next lead" do
      play = Bridge::Play.new(0, "7HN", ["HA", "D2", "C2", "S2"])
      assert_equal "E", play.next_direction
    end
  end

  describe "#card_allowed?" do
    it "returns false if no contract" do
      play = Bridge::Play.new(0, nil, [])
      refute play.card_allowed?("SA")
    end

    it "returns true if card is proper" do
      play = Bridge::Play.new(0, "7SN", ["HA", "D2", "C2"])
      assert play.card_allowed?("S2")
    end

    it "returns false if card already played" do
      play = Bridge::Play.new(0, "7SN", ["HA", "D2", "C2", "S2"])
      refute play.card_allowed?("S2")
    end

    it "returns false if card not in hand of next player" do
      play = Bridge::Play.new(0, "7SN", ["HA", "D2", "C2"])
      refute play.card_allowed?("CA")
    end

    it "returns true for other suit if no more cards in first card suit" do
      play = Bridge::Play.new(636839108127179982824423290, "1SN", ["C5", "CA", "C4", "C3", "C8"])
      assert play.card_allowed?("S6")
    end

    it "returns false if card suit other than firsts card in trick" do
      play = Bridge::Play.new(636839108127179982824423290, "1SN", ["HQ"])
      refute play.card_allowed?("DT")
    end
  end
end

# deal id: 636839108127179982824423290
# "N" => ["SA", "SK", "SQ", "S8", "S6", "HK", "H7", "H6", "H4", "DK", "DQ", "DJ", "C3"]
# "E" => ["S5", "S4", "S3", "HA", "HQ", "HJ", "H9", "D5", "D4", "CK", "CJ", "C9", "C5"]
# "S" => ["ST", "S7", "S2", "HT", "H8", "H2", "DT", "D8", "D3", "CA", "CT", "C6", "C2"]
# "W" => ["SJ", "S9", "H5", "H3", "DA", "D9", "D7", "D6", "D2", "CQ", "C8", "C7", "C4"]
