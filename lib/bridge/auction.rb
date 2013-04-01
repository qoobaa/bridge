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
      if last_contract_index = bids.rindex(&:contract?)
        modifier = bids[last_contract_index..-1].select(&:modifier?).last
        bids[last_contract_index].to_s + modifier.to_s
      end
    end

    def bid_allowed?(bid)
      return false if finished?

      bid = Bid.new(bid.to_s)
    end
  end
end
