module Bridge
  class Score
    attr_reader :tricks, :contract, :declarer, :modifier, :vulnerable

    # Creates new score object
    #
    # ==== Example
    #   Bridge::Score.new(:contract => "7SXX", :declarer => "S", :vulnerable => "NONE", :tricks => 13)
    def initialize(options = {})
      options[:vulnerable] ||= "NONE"
      options[:contract].gsub!(/(X+)/, "")
      @modifier = $1.to_s.size * 2
      @tricks = options[:tricks]
      @contract = Bridge::Bid.new(options[:contract])
      @vulnerable = options[:vulnerable] if Bridge::VULNERABILITIES.include?(options[:vulnerable].upcase)
      @declarer = options[:declarer] if Bridge::DIRECTIONS.include?(options[:declarer].upcase)
    end

    def result
      tricks - tricks_to_make_contract
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

    def made?
      result >= 0
    end

    def small_slam?
      contract.level.to_i == 6
    end

    def grand_slam?
      contract.level.to_i == 7
    end

    def vulnerable?
      case vulnerable
      when "BOTH"
        true
      when "NONE"
        false
      else
        vulnerable.split('').include?(declarer)
      end
    end

    def points
      tricks_points + bonus
    end

    def tricks_points
      if result == 0
        first_trick_points + (contract.level.to_i - 1) * single_trick_points
      elsif result > 0
        first_trick_points + (contract.level.to_i - 1 + result) * single_trick_points
      else
        result * undertrick
      end
    end

    def bonus
      game_bonus + grand_slam_bonus + small_slam_bonus
    end

    def game_bonus
      if made? and tricks_points >= 100
        vulnerable? ? 500 : 300
      elsif made?
        50
      else
        0
      end
    end

    def grand_slam_bonus
      if made? and grand_slam?
        vulnerable? ? 1500 : 1000
      else
        0
      end
    end

    def small_slam_bonus
      if made? and small_slam?
        vulnerable? ? 750 : 500
      else
        0
      end
    end

    def first_trick_points
      contract.no_trump? ? 40 : single_trick_points
    end

    def single_trick_points
      contract.minor? ? 20 : 30
    end

    def undertrick
      # vulnerable or not? doubled, redoubled?
      50
    end
  end
end