module Bridge
  class Play
    attr_reader :deal_id, :contract, :cards

    def initialize(deal_id, contract, cards)
      @deal_id = deal_id
      @contract = contract
      @cards = cards.map { |card| Card.new(card.to_s) }
    end

    def finished?
      cards.length == 52
    end

    def declarer
      contract[-1]
    end

    def trump
      contract[1] if Bridge.trump?(contract[1])
    end

    def card_allowed?(card)
      card = Card.new(card.to_s)
      case
      when !contract, cards.include?(card), !deal[next_direction].include?(card) then false
      when tricks.none?, tricks.last.complete? then true
      else (deal[next_direction] - cards).map(&:suit).uniq.include?(last_lead.suit) ? card.suit == last_lead.suit : true
      end
    end

    def directions
      @directions ||= tricks.map { |trick| trick.cards }.flatten.map { |card| deal.owner(card) }
    end

    def next_direction
      case
      when tricks.none? then Bridge.next_direction(declarer)
      when tricks.last.complete? then directions.last
      else Bridge.next_direction(directions.last)
      end
    end

    def deal
      @deal ||= Deal.from_id(deal_id)
    end

    def tricks
      @tricks ||= begin
        tricks = []
        cards.each_slice(4) { |trick| tricks << Trick.new(*trick) }
        tricks
      end
    end

    private

    def last_lead
      @last_lead ||= tricks.last.cards.first
    end
  end
end
