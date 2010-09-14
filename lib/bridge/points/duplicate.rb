module Bridge::Points
  class Duplicate
    def initialize(*scores)
      @scores = Array(scores).flatten.sort.reverse
    end

    def theoretical_maximum
      (@scores.size - 1) * 2
    end

    def skipped_scores(number = 1)
      @scores[number..(-1 - number)]
    end

    def average_score(number_to_skip = 1)
      scores = skipped_scores(number_to_skip)
      ((scores.inject(0.0) { |result, score| result += score} / scores.size) + 5).div(10) * 10
    end

    def maximum
      {}.tap do |result|
        @scores.each_with_index do |score, i|
          result[score] ||= @scores[(i + 1)..-1].inject(0) { |points, s| points += (score <=> s) + 1 }
        end
      end
    end

    def maximum_in_percents
      maximum.tap do |result|
        result.each do |score, points|
          result[score] = (points * 100.0 / theoretical_maximum)
        end
      end
    end

    def butler(number_to_skip = 1)
      {}.tap do |result|
        @scores.each do |score|
          result[score] = Bridge::Points.imps(score - average_score(number_to_skip))
        end
      end
    end

    def cavendish
      {}.tap do |result|
        @scores.each do |score|
          result[score] ||= @scores.inject(0.0) { |points, s| points += Bridge::Points.imps(score - s) } / (@scores.size - 1)
        end
      end
    end
  end
end
