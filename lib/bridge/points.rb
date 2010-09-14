module Bridge
  module Points
    def self.imps(points_difference)
      sign = (points_difference >= 0) ? 1 : -1
      IMPS.each { |range, imps| return (imps * sign) if range.include?(points_difference.abs) }
      nil
    end
  end
end
