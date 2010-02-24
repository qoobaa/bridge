module Bridge
  class Card
    include Comparable

    attr_reader :card

    # Creates a new card
    def initialize(card)
      @card = card.to_s.upcase
      raise ArgumentError, "invalid card: #{card}" unless Bridge.card?(@card)
    end

    # Returns the suit of the card
    def suit
      card[0]
    end

    # Returns the suit of the card
    def value
      card[1]
    end

    # Compares the card with the other card
    def <=>(other)
      case other
      when Card
        raise ArgumentError, "comparing card of suit #{suit} with suit #{other.suit}" unless suit == other.suit
        Bridge.compare_cards(self.card, other.card)
      when String
        self <=> Card.new(other)
      else
        begin
          a, b = other.coerce(self)
          a <=> b
        rescue
        end
      end
    end

    def eql?(other)
      self == other && other.instance_of?(Card)
    end

    def hash
      card.hash
    end

    def coerce(other)
      [Card.new(other.to_s), self]
    end

    def inspect
      card.inspect
    end

    def to_s
      card
    end
  end

  def self.Card(card)
    Card.new(card)
  end
end
