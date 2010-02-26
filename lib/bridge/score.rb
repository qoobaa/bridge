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
      @declarer = options[:declarer] if Bridge::DIRECTIONS.include?(options[:declarer])
    end

    def result
      tricks - tricks_to_make_contract
    end

    def tricks_to_make_contract
      contract.level.to_i + 6
    end

    def minor?
      ["C", "D"].include?(contract.suit)
    end

    def major?
      not minor?
    end

    def nt?
      contract.suit == "NT"
    end

    def doubled?
      @modifier == 2
    end

    def redoubled?
      @modifier == 4
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
      if result == 0
        first_trick_points + (contract.level.to_i - 1) * trick_points
      elsif result > 0
        first_trick_points + (contract.level.to_i - 1 + result) * trick_points
      else
        result * undertrick
      end
    end

    def first_trick_points
      nt? ? 40 : trick_points
    end

    def trick_points
      minor? ? 20 : 30
    end

    def undertrick
      # vulnerable or not? doubled, redoubled?
      50
    end
  end
end