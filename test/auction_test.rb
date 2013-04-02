require "helper"

describe Bridge::Auction do
  it "raises on invalid bids" do
    assert_raises ArgumentError do
      Bridge::Auction.new(["8NT"])
    end
  end

  describe "#finished?" do
    it "returns false when not finished" do
      refute Bridge::Auction.new(["2NT"]).finished?
    end

    it "returns true when finished" do
      assert Bridge::Auction.new(["2NT", "PASS", "PASS", "PASS"]).finished?
    end
  end

  describe "#contract" do
    it "returns nil when no contract" do
      assert_nil Bridge::Auction.new(["PASS"]).contract
    end

    it "returns current contract" do
      assert_equal "2S", Bridge::Auction.new(["2S", "PASS"]).contract
    end

    it "returns current contract with modifier" do
      assert_equal "2SX", Bridge::Auction.new(["2S", "X", "PASS"]).contract
    end

    it "returns current contract without modifier" do
      assert_equal "2NT", Bridge::Auction.new(["2S", "X", "2NT", "PASS"]).contract
    end
  end

  describe "#bid_allowed?" do
    it "returns false if finished" do
      refute Bridge::Auction.new(["1NT", "PASS", "PASS", "PASS"]).bid_allowed?("PASS")
    end

    it "returns true if PASS" do
      assert Bridge::Auction.new(["1NT", "PASS", "PASS"]).bid_allowed?("PASS")
    end

    it "returns false if bid is lower than previous" do
      refute Bridge::Auction.new(["1NT", "PASS"]).bid_allowed?("1S")
    end

    it "returns true if bid is higher than previous" do
      assert Bridge::Auction.new(["1NT", "PASS", "X"]).bid_allowed?("2C")
    end

    it "returns true if bid is first contract" do
      assert Bridge::Auction.new(["PASS"]).bid_allowed?("2C")
    end

    it "returns true if bid is double on previous contract" do
      assert Bridge::Auction.new(["1C"]).bid_allowed?("X")
    end

    it "returns true if bid is double on previous 2 bids contract" do
      assert Bridge::Auction.new(["1C", "PASS", "PASS"]).bid_allowed?("X")
    end

    it "returns false if bid is double on partner contract" do
      refute Bridge::Auction.new(["1C", "PASS"]).bid_allowed?("X")
    end

    it "returns false if bid is double on PASS" do
      refute Bridge::Auction.new(["PASS"]).bid_allowed?("X")
    end

    it "returns false if bid is double on doubled contract" do
      refute Bridge::Auction.new(["1C", "X", "PASS"]).bid_allowed?("X")
    end

    it "returns true if bid is redouble on doubled previous contract" do
      assert Bridge::Auction.new(["1C", "X"]).bid_allowed?("XX")
    end

    it "returns true if bid is redouble on 2 bids previous dobuled contract" do
      assert Bridge::Auction.new(["1C", "X", "PASS", "PASS"]).bid_allowed?("XX")
    end

    it "returns false if bid is redouble on partners double" do
      refute Bridge::Auction.new(["1C", "X", "PASS"]).bid_allowed?("XX")
    end

    it "returns false if bid is redouble on not doubled contract" do
      refute Bridge::Auction.new(["1C", "PASS", "PASS"]).bid_allowed?("XX")
    end

    it "returns false if bid is redouble on redoubled contract" do
      refute Bridge::Auction.new(["1C", "X", "XX", "PASS"]).bid_allowed?("XX")
    end
  end
end
