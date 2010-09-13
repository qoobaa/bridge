module Bridge::Points
  class Duplicate
    def initialize(*scores)
      @scores = Array(scores).flatten
    end

    def max
      @scores.inject({}) do |result, score|
        result.tap do |r|
          r[score] ||= @scores.inject(-1) { |points, s| points += (score <=> s) + 1 }
        end
      end
    end

    # def max_percents
    #   max.tap do |result|
    #     result.each do |score, points|
    #       result[score] = points * 100.0 / theoretical_max
    #     end
    #   end
    # end

    # protected

    # def theoretical_max
    #   (@scores.size - 1) * 2
    # end
  end
end
