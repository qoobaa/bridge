module Bridge
  class Auction
    attr_reader :bids

    def initialize(bids = [])
      @bids = bids.map { |bid| Bid.new(bid.to_s) }
    end

    def finished?
      bids.length > 3 && bids[-3...-1].all?(&:pass?)
    end

    def contract
      if last_contract = bids.reverse.find(&:contract?).to_s
      end
    end

    def bid_allowed?(bid)
      return false if finished?

      bid = Bid.new(bid.to_s)
    end
  end
end
