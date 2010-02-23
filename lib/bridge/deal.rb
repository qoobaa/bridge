module Bridge
  module Deal
    # Converts given id to deal (hash)
    def self.id_to_deal(id)
      deal = { "N" => [], "E" => [], "S" => [], "W" => [] }
      k = DEALS
      DECK.each_with_index do |card, i|
        x = k * (13 - deal["N"].size) / (52 - i)
        if id < x
          deal["N"] << card
        else
          id -= x
          x = k * (13 - deal["E"].size) / (52 - i)
          if id < x
            deal["E"] << card
          else
            id -= x
            x = k * (13 - deal["S"].size) / (52 - i)
            if id < x
              deal["S"] << card
            else
              id -= x
              x = k * (13 - deal["W"].size) / (52 - i)
              deal["W"] << card
            end
          end
        end
        k = x
      end
      deal
    end

    # Converts given deal (hash) to id
    def self.deal_to_id(d)
      k = DEALS; id = 0
      deal = { "N" => d["N"].dup, "E" => d["E"].dup, "S" => d["S"].dup, "W" => d["W"].dup }
      DECK.each_with_index do |card, i|
        x = k * deal["N"].size / (52 - i)
        unless deal["N"].delete(card)
          id += x
          x = k * deal["E"].size / (52 - i)
          unless deal["E"].delete(card)
            id += x
            x = k * deal["S"].size / (52 - i)
            unless deal["S"].delete(card)
              id += x
              x = k * deal["W"].size / (52 - i)
              deal["W"].delete(card)
            end
          end
        end
        k = x
      end
      id
    end

    # Returns a random deal id
    def self.random_deal_id
      rand(DEALS)
    end

    # Returns a random deal
    def self.random_deal
      id_to_deal(random_deal_id)
    end

    # Checks if the given number is valid deal id
    def self.deal_id?(n)
      (0..DEALS - 1).include?(n)
    end

    # Checks if the given hash is valid deal
    def self.deal?(h)
      if ["N", "E", "S", "W"].all? { |s| h[s] && h[s].size == 13 }
        cards = (h["N"] + h["E"] + h["S"] + h["W"]).uniq
        if cards.size == 52
          cards.all? { |card| DECK.include?(card) }
        else
          false
        end
      else
        false
      end
    end
  end
end
