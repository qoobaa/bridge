module Bridge
  class Trick
    attr_reader :cards, :suit

    def initialize(*args)
      @cards = args.flatten.map { |c| Bridge::Card.new(c.to_s) }
      @suit = @cards.first.suit
    end

    def winner(trump = nil)
      winner_in_suit(trump) || winner_in_suit(suit)
    end

    def complete?
      cards.size == 4
    end

    def incomplete?
      !complete?
    end

    private

    def winner_in_suit(suit)
      cards.select { |c| c.suit == suit }.max
    end
  end
end
