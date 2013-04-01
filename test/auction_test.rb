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
  end
end
