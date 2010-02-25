module Bridge
  class Trick
    attr_reader :cards, :trump, :suit

    def initialize(*args)
      options = args.pop if args.last.is_a?(Hash)
      @cards = args.flatten.map { |s| Bridge::Card.new(s.to_s) }
      @suit = @cards.first.suit
      @trump = options && options[:trump]
    end

    def winner
      winner_in_suit(@trump) || winner_in_suit(@suit)
    end

    private

    def winner_in_suit(suit)
      @cards.select { |c| c.suit == suit }.max
    end
  end
end
