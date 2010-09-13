module Bridge::Points
  class Duplicate
    def initialize(*scores)
      @scores = Array(scores).flatten
    end

    def max
      @scores.inject({}) do |result, score|
        result.tap do |r|
          r[score] ||= @scores.inject(-1) { |partial, s| partial += (score <=> s) + 1 }
        end
      end
    end
  end
end
