module Bridge
  class Score
    attr_reader :tricks, :contract, :vulnerable

    # Creates new score object
    #
    # ==== Example
    #   Bridge::Score.new(:contract => "7SXX", :vulnerable => true, :tricks => "=")
    def initialize(options = {})
      @contract, @modifier = split_contract(options[:contract])
      @tricks = calculate_tricks(options[:tricks].to_s) if (0..13).to_a.include?(calculate_tricks(options[:tricks].to_s))
      @vulnerable = options[:vulnerable] || false
    end

    # Returns nr of overtricks or undertricks. 0 if contract was made without them
    def result
      tricks - tricks_to_make_contract
    end

    # Returns true if contract was made, false otherwise
    def made?
      result >= 0
    end

    # Returns points achieved by declarer: + for made contract - if conctract wasn't made
    def points
      made? ? (made_contract_points + overtrick_points + bonus) : undertrick_points
    end

    #private

    def vulnerable?
      @vulnerable == true
    end

    def tricks_to_make_contract
      contract.level.to_i + 6
    end

    def doubled?
      @modifier == 2
    end

    def redoubled?
      @modifier == 4
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
      if made? and contract.grand_slam?
        vulnerable? ? 1500 : 1000
      else
        0
      end
    end

    def small_slam_bonus
      if made? and contract.small_slam?
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
      contract.no_trump? ? 40 : single_trick_points
    end

    def single_trick_points
      contract.minor? ? 20 : 30
    end

    def undertrick_points
      vulnerable? ? vulnerable_undertrick_points : not_vulnerable_undertrick_points
    end

    def made_contract_points
      first_trick_points * @modifier + (contract.level.to_i - 1) * single_trick_points * @modifier
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
        p = -100 * @modifier
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
        p = -50 * @modifier
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
      if tricks =~ /\A\+\d\Z/
        tricks_to_make_contract + tricks[1..1].to_i
      elsif tricks =~ /\A-\d\Z/
        tricks_to_make_contract - tricks[1..1].to_i
      elsif tricks =~ /\A=\Z/
        tricks_to_make_contract.to_i
      else
        tricks.to_i
      end
    end

    def split_contract(contract)
      contract = contract.gsub(/(X+)/, "")
      modifier = $1.nil? ? 1 : $1.to_s.size * 2
      [Bridge::Bid.new(contract), modifier]
    end
  end
end