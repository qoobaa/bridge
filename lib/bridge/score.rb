module Bridge
  class Score
    attr_reader :contract, :vulnerable, :tricks_number

    # Creates new score object
    #
    # ==== Example
    #   Bridge::Score.new("7SXXN", "NS", 0)
    def initialize(contract, vulnerable, tricks)
      @contract      = contract
      @vulnerable    = vulnerable
      @tricks_number = calculate_tricks(tricks)
    end

    # Returns all possible contracts with given points
    def self.with_points(points)
      all_contracts.select { |contract, result| result == points }.keys.sort
    end

    # Returns nr of overtricks or undertricks. 0 if contract was made without them
    def result
      tricks_number - tricks_to_make_contract
    end

    # Returns string with nr of tricks relative to contract level
    def result_string
      case
      when result > 0  then "+#{result}"
      when result == 0 then "="
      when result < 0  then result.to_s
      end
    end

    # Returns true if contract was made, false otherwise
    def made?
      result >= 0
    end

    # Returns points achieved by declarer: + for made contract - if conctract wasn't made
    def points
      made? ? (made_contract_points + overtrick_points + bonus) : undertrick_points
    end

    # Returns if declarer side is vulnerable
    def vulnerable?
      case vulnerable
      when "BOTH" then true
      when "NONE" then false
      else
        vulnerable.split("").include?(declarer)
      end
    end

    private

    def contract_bid
      @contract_bid ||= Bid.new(contract.match(Bridge::CONTRACT_REGEXP)[:bid])
    end

    def declarer
      @declarer ||= contract.match(Bridge::CONTRACT_REGEXP)[:direction]
    end

    def tricks_to_make_contract
      @tricks_to_make_contract ||= contract_bid.level.to_i + 6
    end

    def doubled?
      modifier == 2
    end

    def redoubled?
      modifier == 4
    end

    def modifier
      case contract.match(Bridge::CONTRACT_REGEXP)[:modifier]
      when nil  then 1
      when "X"  then 2
      when "XX" then 4
      end
    end

    def bonus
      game_bonus + grand_slam_bonus + small_slam_bonus + doubled_bonus + redoubled_bonus
    end

    def game_bonus
      if made? and made_contract_points >= 100
        vulnerable? ? 500 : 300
      elsif made?
        50
      else
        0
      end
    end

    def grand_slam_bonus
      if made? and contract_bid.grand_slam?
        vulnerable? ? 1500 : 1000
      else
        0
      end
    end

    def small_slam_bonus
      if made? and contract_bid.small_slam?
        vulnerable? ? 750 : 500
      else
        0
      end
    end

    def doubled_bonus
      (made? and doubled?) ? 50 : 0
    end

    def redoubled_bonus
      (made? and redoubled?) ? 100 : 0
    end

    def first_trick_points
      contract_bid.no_trump? ? 40 : single_trick_points
    end

    def single_trick_points
      contract_bid.minor? ? 20 : 30
    end

    def undertrick_points
      vulnerable? ? vulnerable_undertrick_points : not_vulnerable_undertrick_points
    end

    def made_contract_points
      first_trick_points * modifier + (contract_bid.level.to_i - 1) * single_trick_points * modifier
    end

    def overtrick_points
      if doubled?
        vulnerable? ? result * 200 : result * 100
      elsif redoubled?
        vulnerable? ? result * 400 : result * 200
      else
        result * single_trick_points
      end
    end

    # TODO: do some refactoring
    def vulnerable_undertrick_points
      if !made?
        p = -100 * modifier
        if result < -1
          return p += (result + 1) * 300 if doubled?
          return p += (result + 1) * 600 if redoubled?
          return p += (result + 1) * 100
        end
        p
      else
        0
      end
    end

    def not_vulnerable_undertrick_points
      if !made?
        p = -50 * modifier
        if [-3, -2].include?(result)
          return p += (result + 1) * 200 if doubled?
          return p += (result + 1) * 400 if redoubled?
          return p += (result + 1) * 50 if (!doubled? and !redoubled?)
        elsif result < -3
          return p += (-2 * 200 + (result + 3) * 300) if doubled?
          return p += (-2 * 400 + (result + 3) * 600) if redoubled?
          return p += (result + 1) * 50 if (!doubled? and !redoubled?)
        end
        p
      else
        0
      end
    end

    def calculate_tricks(tricks)
      if tricks.kind_of? Numeric
        tricks
      elsif tricks =~ /\A\+\d\Z/
        tricks_to_make_contract + tricks[1..1].to_i
      elsif tricks =~ /\A-\d\Z/
        tricks_to_make_contract - tricks[1..1].to_i
      elsif tricks =~ /\A=\Z/
        tricks_to_make_contract
      elsif tricks =~ /\A\d[0-3]?\Z/
        tricks.to_i
      end
    end

    def self.all_contracts
      result = {}
      contracts = %w(1 2 3 4 5 6 7).inject([]) do |bids, level|
        bids += ["H/S", "C/D", "NT"].map { |suit| level + suit }
      end
      (contracts + contracts.map { |c| c + "X" } + contracts.map { |c| c + "XX" } ).each do |contract|
        ["BOTH", "NONE"].each do |vulnerable|
          (0..13).each do |tricks|
            score = new(contract.sub("H/S", "S").sub("C/D", "C").sub("NT", "NT") + "N", vulnerable, tricks)
            result[contract + score.result_string + (score.vulnerable? ? "v" : "")] = score.points
          end
        end
      end
      result
    end
  end
end
