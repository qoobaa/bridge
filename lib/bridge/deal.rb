module Bridge

  # Class representing bridge deal
  class Deal
    include Comparable

    attr_reader :n, :e, :s, :w

    # Returns cards of given direction
    def [](direction)
      must_be_direction!(direction)
      send("#{direction.to_s.downcase}")
    end

    # Compares the deal with given deal
    def <=>(other)
      id <=> other.id
    end

    # Creates new deal object with cards given in hash of directions
    #
    # ==== Example
    #   Bridge::Deal.new(:n => ["HA", ...], :s => ["SA"], ...)
    def initialize(hands)
      hands.each do |hand, cards|
        self[hand] = cards.map { |c| Card.new(c) }
      end
    end

    # Converts given id to deal
    def self.from_id(id)
      raise ArgumentError, "invalid deal id: #{id}" unless Bridge.deal_id?(id)
      n = []; e = []; s = []; w = []; k = DEALS
      DECK.each_with_index do |card, i|
        card = Card.new(card)
        x = k * (13 - n.size) / (52 - i)
        if id < x
          n << card
        else
          id -= x
          x = k * (13 - e.size) / (52 - i)
          if id < x
            e << card
          else
            id -= x
            x = k * (13 - s.size) / (52 - i)
            if id < x
              s << card
            else
              id -= x
              x = k * (13 - w.size) / (52 - i)
              w << card
            end
          end
        end
        k = x
      end
      new(:n => n, :e => e, :s => s, :w => w)
    end

    # Converts given deal (hash) to id
    def id
      k = DEALS; id = 0; n = self.n.dup; e = self.e.dup; s = self.s.dup; w = self.w.dup
      DECK.each_with_index do |card, i|
        x = k * n.size / (52 - i)
        unless n.delete(card)
          id += x
          x = k * e.size / (52 - i)
          unless e.delete(card)
            id += x
            x = k * s.size / (52 - i)
            unless s.delete(card)
              id += x
              x = k * w.size / (52 - i)
              w.delete(card)
            end
          end
        end
        k = x
      end
      id
    end

    # Returns the direction that owns the card
    def owner(card)
      DIRECTIONS.find { |direction| self[direction].include?(card) }
    end

    # Returns a random deal id
    def self.random_id
      rand(DEALS)
    end

    # Returns a random deal
    def self.random
      from_id(random_id)
    end

    # Checks if the deal is a valid deal
    def valid?
      if DIRECTIONS.all? { |d| self[d] && self[d].size == 13 }
        cards = (n + e + s + w).uniq
        if cards.size == 52
          cards.all? { |card| Bridge.card?(card.to_s) }
        else
          false
        end
      else
        false
      end
    end

    def inspect
      { "N" => n, "E" => e, "S" => s, "W" => w }.inspect
    end

    private

    def must_be_direction!(string)
      raise ArgumentError, "invalid direction: #{string}" unless Bridge.direction?(string.to_s.upcase)
    end

    def []=(direction, cards)
      must_be_direction!(direction)
      instance_variable_set("@#{direction.to_s.downcase}", cards)
    end
  end
end
