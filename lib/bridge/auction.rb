module Bridge
  class Auction
    attr_reader :dealer, :bids

    def initialize(dealer, bids)
      raise ArgumentError, "invalid direction: #{dealer}" unless Bridge.direction?(dealer)
      @dealer = dealer
      @bids = bids.map { |bid| Bid.new(bid.to_s) }
    end

    def finished?
      bids.length > 3 && bids[-3..-1].all?(&:pass?)
    end

    def contract
      if last_contract_index
        modifier = bids[last_contract_index..-1].select(&:modifier?).last
        bids[last_contract_index].to_s + modifier.to_s + declarer
      end
    end

    def bid_allowed?(bid)
      bid = Bid.new(bid.to_s)
      return false if finished?
      case
      when bid.pass?     then true
      when bid.contract? then contract_allowed?(bid)
      when bid.double?   then double_allowed?
      when bid.redouble? then redouble_allowed?
      end
    end

    def declarer
      direction = dealer
      last_contract_index.times { direction = Bridge.next_direction(direction) }
      direction
    end

    def directions
      @directions ||= begin
        return [] if bids.none?
        directions = [dealer]
        (bids.count - 1).times { directions << Bridge.next_direction(directions.last) }
        directions
      end
    end

    def next_direction
      @next_direction ||= directions.none? ? dealer : Bridge.next_direction(directions.last)
    end

    private

    def last_contract_index
      return @last_contract_index if defined?(@last_contract_index)
      @last_contract_index = bids.rindex(&:contract?)
    end

    def contract_allowed?(bid)
      last_contract_index ? bids[last_contract_index] < bid : true
    end

    def double_allowed?
      return false unless last_contract_index
      after_contract_bids = bids[(last_contract_index + 1)..-1]
      after_contract_bids.all?(&:pass?) && !after_contract_bids.one?
    end

    def redouble_allowed?
      return false unless last_contract_index
      return false unless last_double_index = bids.rindex(&:double?)
      return false if last_double_index < last_contract_index
      after_double_bids = bids[(last_double_index + 1)..-1]
      after_double_bids.all?(&:pass?) && !after_double_bids.one?
    end
  end
end
