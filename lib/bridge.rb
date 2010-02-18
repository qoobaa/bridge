module Bridge

  # Total number of possible deals in bridge
  DEALS = 53_644_737_765_488_792_839_237_440_000

  # Array with cards in the bridge deck (from two to ace, four suits)
  DECK = %w(S H D C).inject([]) do |d, s|
    d += %w(A K Q J T 9 8 7 6 5 4 3 2).map { |c| c + s }
  end

  # Converts given number to deal (hash)
  def self.number_to_deal(number)
    deal = { :n => [], :e => [], :s => [], :w => [] }
    k = DEALS
    DECK.each_with_index do |card, i|
      x = k * (13 - deal[:n].size) / (52 - i)
      if number < x
        deal[:n] << card
      else
        number -= x
        x = k * (13 - deal[:e].size) / (52 - i)
        if number < x
          deal[:e] << card
        else
          number -= x
          x = k * (13 - deal[:s].size) / (52 - i)
          if number < x
            deal[:s] << card
          else
            number -= x
            x = k * (13 - deal[:w].size) / (52 - i)
            deal[:w] << card
          end
        end
      end
      k = x
    end
    deal
  end

  # Converts given deal (hash) to number
  def self.deal_to_number(d)
    k = DEALS; number = 0
    deal = { :n => d[:n].dup, :e => d[:e].dup, :s => d[:s].dup, :w => d[:w].dup }
    DECK.each_with_index do |card, i|
      x = k * deal[:n].size / (52 - i)
      unless deal[:n].delete(card)
        number += x
        x = k * deal[:e].size / (52 - i)
        unless deal[:e].delete(card)
          number += x
          x = k * deal[:s].size / (52 - i)
          unless deal[:s].delete(card)
            number += x
            x = k * deal[:w].size / (52 - i)
            deal[:w].delete(card)
          end
        end
      end
      k = x
    end
    number
  end

  # Returns a random deal number
  def self.random_deal_number
    rand(DEALS)
  end

  # Returns a random deal
  def self.random_deal
    number_to_deal(random_deal_number)
  end

  # Checks if the given number is valid deal number
  def self.deal_number?(n)
    (0..DEALS - 1).include?(n)
  end

  # Checks if the given hash is valid deal
  def self.deal?(h)
    if [:n, :e, :s, :w].all? { |s| h[s] && h[s].size == 13 }
      cards = (h[:n] + h[:e] + h[:s] + h[:w]).uniq
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
