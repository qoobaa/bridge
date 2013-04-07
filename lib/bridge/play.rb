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
      contract[-1] if contract
    end

    def dummy
      Bridge.partner_of(declarer) if contract
    end

    def left_hand_opponent
      Bridge.next_direction(declarer) if contract
    end
    alias :lho :left_hand_opponent

    def right_hand_opponent
      Bridge.partner_of(left_hand_opponent) if contract
    end
    alias :rho :right_hand_opponent

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
      when tricks.last.complete? then deal.owner(tricks.last.winner(trump))
      else Bridge.next_direction(directions.last)
      end
    end

    def declarer_tricks_number
      tricks.map { |trick| deal.owner(trick.winner(trump)) }.count { |direction| [declarer, dummy].include?(direction) }
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
