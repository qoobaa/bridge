module Bridge::Points
  class Chicago
    attr_reader :hcp, :points, :vulnerable
    alias :vulnerable? :vulnerable

    # Creates new Imp object
    #
    # ==== Example
    #   Bridge::Points::Chicago.new(:hcp => 25, :points => 420, :vulnerable => true)
    def initialize(options = {})
      @hcp = options[:hcp]
      raise ArgumentError, "Invalid hcp: #{hcp} - value should be between 20 and 40" unless (20..40).include?(hcp)
      @points = options[:points]
      @vulnerable = options[:vulnerable] || false
    end

    # Returns points that side should make with given hcp
    def points_to_make
      POINTS[hcp][vulnerable? ? 1 : 0]
    end

    # Returns points score relative to hcp
    def points_difference
      points - points_to_make
    end

    # Returns imps (negative or positive) based on given points
    def imps
      IMPS.each do |range, imps|
        return (imps * sign) if range.include?(points_difference.abs)
      end
      nil
    end

    private

    def sign
      points >= 0 ? 1 : -1
    end
  end
end
