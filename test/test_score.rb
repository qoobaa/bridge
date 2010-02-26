require "helper"

class TestScore < Test::Unit::TestCase

  def setup
    @score = Bridge::Score.new(:contract => "1S", :declarer => "N", :vulnerable => "NONE", :tricks => 9)
  end

  test "valid score" do
    assert_false @score.contract.nil?
    assert_false @score.declarer.nil?
    assert_false @score.vulnerable.nil?
    assert_false @score.tricks.nil?
  end

  test "default vulnerable set to NONE" do
    score = Bridge::Score.new(:contract => "1S", :declarer => "N", :tricks => 9)
    assert_equal "NONE", score.vulnerable
  end

  test "return modifier and contract when doubled" do
    score = Bridge::Score.new(:contract => "4SX", :declarer => "N", :tricks => 9)
    assert_equal 2, score.modifier
    assert_equal "4S", score.contract.to_s
  end

  test "return modifier and contract when redoubled" do
    score = Bridge::Score.new(:contract => "4SXX", :declarer => "N", :tricks => 9)
    assert_equal 4, score.modifier
    assert_equal "4S", score.contract.to_s
  end

  test "return tricks to make contract" do
    assert_equal 7, @score.tricks_to_make_contract
    score = Bridge::Score.new(:contract => "6S", :declarer => "N", :tricks => 9)
    assert_equal 12, score.tricks_to_make_contract
  end

  test "return made contract?" do
    score = Bridge::Score.new(:contract => "6S", :declarer => "N", :tricks => 9)
    assert_false score.made?
    score = Bridge::Score.new(:contract => "3NT", :declarer => "N", :vulnerable => "BOTH", :tricks => 3)
    assert_false score.made?
    score = Bridge::Score.new(:contract => "7NT", :declarer => "N", :vulnerable => "BOTH", :tricks => 13)
    assert score.made?
    score = Bridge::Score.new(:contract => "3NT", :declarer => "N", :vulnerable => "BOTH", :tricks => 11)
    assert score.made?
  end

  test "return result" do
    assert_equal 2, @score.result
    score = Bridge::Score.new(:contract => "6S", :declarer => "N", :tricks => 12)
    assert_equal 0, score.result
    score = Bridge::Score.new(:contract => "6S", :declarer => "N", :tricks => 10)
    assert_equal -2, score.result
  end

  test "return vulnerable" do
    assert_false @score.vulnerable?
    score = Bridge::Score.new(:contract => "6S", :declarer => "N", :vulnerable => "BOTH", :tricks => 12)
    assert score.vulnerable?
    score = Bridge::Score.new(:contract => "6S", :declarer => "N", :vulnerable => "NS", :tricks => 10)
    assert score.vulnerable?
    score = Bridge::Score.new(:contract => "6S", :declarer => "E", :vulnerable => "NS", :tricks => 10)
    assert_false score.vulnerable?
  end
end

class TestScorePoints < Test::Unit::TestCase

  test "game bonus" do
    score = Bridge::Score.new(:contract => "3S", :declarer => "N", :vulnerable => "NONE", :tricks => 9)
    assert_equal 50, score.game_bonus
    score = Bridge::Score.new(:contract => "4S", :declarer => "N", :vulnerable => "NONE", :tricks => 10)
    assert_equal 300, score.game_bonus
    score = Bridge::Score.new(:contract => "6S", :declarer => "N", :vulnerable => "NONE", :tricks => 12)
    assert_equal 300, score.game_bonus
    score = Bridge::Score.new(:contract => "3NT", :declarer => "N", :vulnerable => "BOTH", :tricks => 9)
    assert_equal 500, score.game_bonus
    score = Bridge::Score.new(:contract => "3NT", :declarer => "N", :vulnerable => "BOTH", :tricks => 3)
    assert_equal 0, score.game_bonus
  end

  test "small slam bonus" do
    score = Bridge::Score.new(:contract => "6S", :declarer => "N", :vulnerable => "NONE", :tricks => 12)
    assert_equal 500, score.small_slam_bonus
    score = Bridge::Score.new(:contract => "6S", :declarer => "N", :vulnerable => "BOTH", :tricks => 12)
    assert_equal 750, score.small_slam_bonus
    score = Bridge::Score.new(:contract => "6S", :declarer => "N", :vulnerable => "BOTH", :tricks => 10)
    assert_equal 0, score.small_slam_bonus
  end

  test "grand slam bonus" do
    score = Bridge::Score.new(:contract => "7S", :declarer => "N", :vulnerable => "NONE", :tricks => 13)
    assert_equal 1000, score.grand_slam_bonus
    score = Bridge::Score.new(:contract => "7S", :declarer => "N", :vulnerable => "BOTH", :tricks => 13)
    assert_equal 1500, score.grand_slam_bonus
    score = Bridge::Score.new(:contract => "7S", :declarer => "N", :vulnerable => "BOTH", :tricks => 11)
    assert_equal 0, score.grand_slam_bonus
    score = Bridge::Score.new(:contract => "6S", :declarer => "N", :vulnerable => "BOTH", :tricks => 13)
    assert_equal 0, score.grand_slam_bonus
  end

  test "doubled and redoubled cotract made bonus" do
    score = Bridge::Score.new(:contract => "4SX", :declarer => "N", :tricks => 10)
    assert_equal 50, score.doubled_bonus
    score = Bridge::Score.new(:contract => "4SXX", :declarer => "N", :tricks => 10)
    assert_equal 100, score.redoubled_bonus
    assert_equal 0, score.doubled_bonus
  end

  test "vulnerable undertrick points" do
    score = Bridge::Score.new(:contract => "4S", :declarer => "N", :vulnerable => "BOTH", :tricks => 9)
    assert_equal -100, score.vulnerable_undertrick_points
    score = Bridge::Score.new(:contract => "4SX", :declarer => "N", :vulnerable => "BOTH", :tricks => 9)
    assert_equal -200, score.vulnerable_undertrick_points
    score = Bridge::Score.new(:contract => "4SX", :declarer => "N", :vulnerable => "BOTH", :tricks => 7)
    assert_equal -800, score.vulnerable_undertrick_points
    score = Bridge::Score.new(:contract => "4SXX", :declarer => "N", :vulnerable => "BOTH", :tricks => 9)
    assert_equal -400, score.vulnerable_undertrick_points
    score = Bridge::Score.new(:contract => "4SXX", :declarer => "N", :vulnerable => "BOTH", :tricks => 7)
    assert_equal -1600, score.vulnerable_undertrick_points
  end

  test "not vulnerable undertrick points" do
    score = Bridge::Score.new(:contract => "4S", :declarer => "N", :vulnerable => "NONE", :tricks => 9)
    assert_equal -50, score.not_vulnerable_undertrick_points
    score = Bridge::Score.new(:contract => "4SX", :declarer => "N", :vulnerable => "NONE", :tricks => 9)
    assert_equal -100, score.not_vulnerable_undertrick_points
    score = Bridge::Score.new(:contract => "4SX", :declarer => "N", :vulnerable => "NONE", :tricks => 7)
    assert_equal -500, score.not_vulnerable_undertrick_points
    score = Bridge::Score.new(:contract => "4SXX", :declarer => "N", :vulnerable => "NONE", :tricks => 9)
    assert_equal -200, score.not_vulnerable_undertrick_points
    score = Bridge::Score.new(:contract => "4SXX", :declarer => "N", :vulnerable => "NONE", :tricks => 7)
    assert_equal -1000, score.not_vulnerable_undertrick_points
    score = Bridge::Score.new(:contract => "4SX", :declarer => "N", :vulnerable => "NONE", :tricks => 6)
    assert_equal -800, score.not_vulnerable_undertrick_points
    score = Bridge::Score.new(:contract => "4SXX", :declarer => "N", :vulnerable => "NONE", :tricks => 6)
    assert_equal -1600, score.not_vulnerable_undertrick_points
    score = Bridge::Score.new(:contract => "4S", :declarer => "N", :vulnerable => "NONE", :tricks => 6)
    assert_equal -200, score.not_vulnerable_undertrick_points
  end

  test "return 90 points for 1S=" do
    score = Bridge::Score.new(:contract => "3S", :declarer => "N", :vulnerable => "NONE", :tricks => 9)
    assert_equal 140, score.points
  end

  test "return 70 points for 2S=" do
    score = Bridge::Score.new(:contract => "2NT", :declarer => "N", :vulnerable => "NONE", :tricks => 8)
    assert_equal 120, score.points
  end

  test "return 80 points for 2D+2" do
    score = Bridge::Score.new(:contract => "2D", :declarer => "N", :vulnerable => "NONE", :tricks => 10)
    assert_equal 130, score.points
  end
end