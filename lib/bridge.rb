require "bridge/card"
require "bridge/deal"
require "bridge/bid"

module Bridge
  # Number of possible deals in bridge
  DEALS = 53_644_737_765_488_792_839_237_440_000

  # Array with card strings in the bridge deck (AKQJT98765432, four
  # suits). Contains "SA", "HT", etc.
  DECK = %w(S H D C).inject([]) do |d, s|
    d += %w(A K Q J T 9 8 7 6 5 4 3 2).map { |c| s + c }
  end

  # Direction strings "N", "E", "S" and "W"
  DIRECTIONS = %w(N E S W)

  # Possible contracts in ascending order. Contains "1C", "6NT", etc.
  CONTRACTS = %w(1 2 3 4 5 6 7).inject([]) do |b, l|
    b += %w(C D H S NT).map { |s| l + s }
  end

  # Pass string
  PASS = "PASS"

  # Double string
  DOUBLE = "X"

  # Redouble string
  REDOUBLE = "XX"

  # Modifier bids (double and redouble)
  MODIFIERS = [DOUBLE, REDOUBLE]

  # All possible bids (including contracts, modifiers and pass)
  BIDS = CONTRACTS + MODIFIERS + [PASS]

  def self.direction?(string)
    DIRECTIONS.include?(string)
  end

  def self.deal_id?(integer)
    (0..DEALS - 1).include?(integer)
  end

  def self.card?(string)
    DECK.include?(string)
  end

  def self.compare_cards(first, second)
    # DECK has reversed order
    DECK.index(second) <=> DECK.index(first)
  end

  def self.compare_contracts(first, second)
    CONTRACTS.index(first) <=> CONTRACTS.index(second)
  end

  def self.pass?(string)
    PASS == string
  end

  def self.double?(string)
    DOUBLE == string
  end

  def self.redouble?(string)
    REDOUBLE == string
  end

  def self.modifier?(string)
    MODIFIERS.include?(string)
  end

  def self.contract?(string)
    CONTRACTS.include?(string)
  end

  def self.bid?(string)
    BIDS.include?(string)
  end
end

# Constructor shortcuts
def Bid(string)
  Bridge::Bid.new(string)
end

def Card(string)
  Bridge::Card.new(string)
end
