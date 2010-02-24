module Bridge
  class Bid
    include Comparable

    attr_reader :bid

    # Creates a new bid
    def initialize(bid)
      @bid = bid.to_s.upcase
      raise ArgumentError, "invalid bid: #{bid}" unless Bridge.bid?(@bid)
    end

    # Returns the level of the bid
    def level
      bid[0] if contract?
    end

    # Returns the suit of the bid
    def suit
      bid[1..-1] if contract?
    end

    def trump
      suit if Bridge.trump?(suit)
    end

    def pass?
      Bridge.pass?(bid)
    end

    def double?
      Bridge.double?(bid)
    end

    def redouble?
      Bridge.redouble?(bid)
    end

    def modifier?
      Bridge.modifier?(bid)
    end

    def contract?
      Bridge.contract?(bid)
    end

    def <=>(other)
      case other
      when Bid
        if contract?
          raise ArgumentError, "could not compare contract bid with non-contract bid #{other}" unless other.contract?
          Bridge.compare_contracts(self.bid, other.bid)
        elsif pass?
          raise ArgumentError, "could not compare pass bid with non-pass bid #{other}" unless other.pass?
          bid <=> other.bid
        elsif double?
          raise ArgumentError, "could not compare double bid with non-double bid #{other}" unless other.double?
          bid <=> other.bid
        elsif redouble?
          raise ArgumentError, "could not compare redouble bid with non-redouble bid #{other}" unless other.redouble?
          bid <=> other.bid
        end
      when String
        self <=> Bid.new(other)
      else
        begin
          a, b = other.coerce(self)
          a <=> b
        rescue
        end
      end
    end

    def coerce(other)
      [Bid.new(other.to_s), self]
    end

    def eql?(other)
      self == other && other.instance_of?(Bid)
    end

    def hash
      bid.hash
    end

    def to_s
      bid
    end

    def inspect
      bid.inspect
    end
  end
end
