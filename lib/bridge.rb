require "bridge/constants"
require "bridge/bid"
require "bridge/card"
require "bridge/auction"
require "bridge/deal"
require "bridge/points"
require "bridge/points/chicago"
require "bridge/points/duplicate"
require "bridge/score"
require "bridge/trick"
require "bridge/version"

module Bridge
  def self.direction?(string)
    DIRECTIONS.include?(string)
  end

  def self.deal_id?(integer)
    (0...DEALS).include?(integer)
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

  def self.trump?(string)
    TRUMPS.include?(string)
  end

  def self.minor?(string)
    MINORS.include?(string)
  end

  def self.major?(string)
    MAJORS.include?(string)
  end

  def self.no_trump?(string)
    NO_TRUMP == string
  end

  def self.partner_of(direction)
    return unless direction?(direction)
    i = (DIRECTIONS.index(direction) + 2) % 4
    DIRECTIONS[i]
  end

  def self.side_of(direction)
    return unless direction?(direction)
    [direction, partner_of(direction)].sort.join
  end

  def self.next_direction(direction = nil)
    return DIRECTIONS.first if direction.nil?
    return unless direction?(direction)
    next_in_collection(DIRECTIONS, direction)
  end

  def self.vulnerable_in_deal(deal = nil)
    return VULNERABILITIES.first if deal.nil?
    round = (deal - 1).div(4) % 4
    index = (deal - 1) % 4
    vulnerabilities = VULNERABILITIES.dup
    shift = vulnerabilities.shift(round)
    vulnerabilities.push(shift).flatten[index]
  end

  def self.next_in_collection(collection, current)
    i = (collection.index(current) + 1) % collection.size
    collection[i]
  end
end
