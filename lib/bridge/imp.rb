module Bridge
  class Imp
    attr_reader :hcp, :points, :vulnerable
    alias :vulnerable? :vulnerable

    # Creates new Imp object
    #
    # ==== Example
    #   Bridge::Imp.new(:hcp => 25, :points => 420, :vulnerable => true)
    def initialize(options = {})
      @hcp = options[:hcp]
      raise ArgumentError, "Invalid hcp: #{hcp} - value should be between 20 and 40" unless (20..40).include?(hcp)
      @points = options[:points]
      @vulnerable = options[:vulnerable] || false
    end

    # values in array: [not-vulnerable, vulnerable]
    POINTS =
      {
        "20" => [0,    0],
        "21" => [50,   50],
        "22" => [70,   70],
        "23" => [110,  110],
        "24" => [200,  290],
        "25" => [300,  440],
        "26" => [350,  520],
        "27" => [400,  600],
        "28" => [430,  630],
        "29" => [460,  660],
        "30" => [490,  690],
        "31" => [600,  900],
        "32" => [700,  1050],
        "33" => [900,  1350],
        "34" => [1000, 1500],
        "35" => [1100, 1650],
        "36" => [1200, 1800],
        "37" => [1300, 1950],
        "38" => [1300, 1950],
        "39" => [1300, 1950],
        "40" => [1300, 1950]
      }

      IMPS =
        {
          "0...10"      => 0,
          "20...40"     => 1,
          "50...80"     => 2,
          "90...120"    => 3,
          "130...160"   => 4,
          "170...210"   => 5,
          "220...260"   => 6,
          "270...310"   => 7,
          "320...360"   => 8,
          "370...420"   => 9,
          "430...490"   => 10,
          "500...590"   => 11,
          "600...740"   => 12,
          "750...890"   => 13,
          "900...1090"  => 14,
          "1100...1290" => 15,
          "1300...1490" => 16,
          "1500...1740" => 17,
          "1750...1990" => 18,
          "2000...2240" => 19,
          "2250...2490" => 20,
          "2500...2990" => 21,
          "3000...3490" => 22,
          "3500...3990" => 23
        }

    def points_to_make
      POINTS[hcp.to_s][vulnerable? ? 1 : 0]
    end

    def points_difference
      points - points_to_make
    end

    def imps
      IMPS.each do |range, imps|
        return (imps * sign) if eval(range).include?(points_difference.abs)
      end
    end

    private

    def sign
      points >= 0 ? 1 : -1
    end
  end
end
