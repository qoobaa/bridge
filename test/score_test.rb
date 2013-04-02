require "helper"

describe Bridge::Score do
  before do
    @score = Bridge::Score.new(:contract => "1S", :vulnerable => false, :tricks => 9)
  end

  it "valid score" do
    refute @score.contract.nil?
    refute @score.vulnerable.nil?
    refute @score.tricks.nil?
  end

  it "default vulnerable set to false" do
    score = Bridge::Score.new(:contract => "1S", :tricks => 9)
    assert_equal false, score.vulnerable
  end

  it "return modifier and contract when doubled" do
    score = Bridge::Score.new(:contract => "4SX", :tricks => 9)
    assert_equal 2, score.instance_variable_get(:@modifier)
    assert_equal "4S", score.contract.to_s
  end

  it "return modifier and contract when redoubled" do
    score = Bridge::Score.new(:contract => "4SXX", :tricks => 9)
    assert_equal 4, score.instance_variable_get(:@modifier)
    assert_equal "4S", score.contract.to_s
  end

  it "return tricks to make contract" do
    assert_equal 7, @score.tricks_to_make_contract
    score = Bridge::Score.new(:contract => "6S", :tricks => 9)
    assert_equal 12, score.tricks_to_make_contract
  end

  it "return made contract?" do
    score = Bridge::Score.new(:contract => "6S", :tricks => 9)
    refute score.made?
    score = Bridge::Score.new(:contract => "3NT", :tricks => 3)
    refute score.made?
    score = Bridge::Score.new(:contract => "7NT", :tricks => 13)
    assert score.made?
    score = Bridge::Score.new(:contract => "3NT", :tricks => 11)
    assert score.made?
  end

  it "return result" do
    assert_equal 2, @score.result
    score = Bridge::Score.new(:contract => "6S", :tricks => 12)
    assert_equal 0, score.result
    score = Bridge::Score.new(:contract => "6S", :tricks => 10)
    assert_equal -2, score.result
  end

  it "return result string" do
    assert_equal "+2", @score.result_string
    score = Bridge::Score.new(:contract => "6S", :tricks => 12)
    assert_equal "=", score.result_string
    score = Bridge::Score.new(:contract => "6S", :tricks => 10)
    assert_equal "-2", score.result_string
  end

  it "return vulnerable" do
    refute @score.vulnerable?
    score = Bridge::Score.new(:contract => "6S", :vulnerable => true, :tricks => 12)
    assert score.vulnerable?
    score = Bridge::Score.new(:contract => "6S", :vulnerable => false, :tricks => 10)
    refute score.vulnerable?
  end

  it "calculate tricks with plus" do
    score = Bridge::Score.new(:contract => "4S", :tricks => "+1")
    assert_equal 11, score.tricks
  end

  it "calculate tricks with minus" do
    score = Bridge::Score.new(:contract => "4S", :tricks => "-4")
    assert_equal 6, score.tricks
  end

  it "calculate tricks with equal sign" do
    score = Bridge::Score.new(:contract => "4S", :tricks => "=")
    assert_equal 10, score.tricks
  end

  it "15 is not a valid tricks argument" do
    assert_raises(ArgumentError) do
      Bridge::Score.new(:contract => "4S", :tricks => 15)
    end
  end

  it "wrong string is not a valid tricks argument" do
    assert_raises(ArgumentError) do
      Bridge::Score.new(:contract => "4S", :tricks => "wrong")
    end
  end

  describe "points" do
    it "game bonus" do
      score = Bridge::Score.new(:contract => "3S", :vulnerable => false, :tricks => 9)
      assert_equal 50, score.game_bonus
      score = Bridge::Score.new(:contract => "4S", :vulnerable => false, :tricks => 10)
      assert_equal 300, score.game_bonus
      score = Bridge::Score.new(:contract => "6S", :vulnerable => false, :tricks => 12)
      assert_equal 300, score.game_bonus
      score = Bridge::Score.new(:contract => "3NT", :vulnerable => true, :tricks => 9)
      assert_equal 500, score.game_bonus
      score = Bridge::Score.new(:contract => "3NT", :vulnerable => true, :tricks => 3)
      assert_equal 0, score.game_bonus
      score = Bridge::Score.new(:contract => "3SX", :vulnerable => true, :tricks => 9)
      assert_equal 500, score.game_bonus
    end

    it "small slam bonus" do
      score = Bridge::Score.new(:contract => "6S", :vulnerable => false, :tricks => 12)
      assert_equal 500, score.small_slam_bonus
      score = Bridge::Score.new(:contract => "6S", :vulnerable => true, :tricks => 12)
      assert_equal 750, score.small_slam_bonus
      score = Bridge::Score.new(:contract => "6S", :vulnerable => true, :tricks => 10)
      assert_equal 0, score.small_slam_bonus
    end

    it "grand slam bonus" do
      score = Bridge::Score.new(:contract => "7S", :vulnerable => false, :tricks => 13)
      assert_equal 1000, score.grand_slam_bonus
      score = Bridge::Score.new(:contract => "7S", :vulnerable => true, :tricks => 13)
      assert_equal 1500, score.grand_slam_bonus
      score = Bridge::Score.new(:contract => "7S", :vulnerable => true, :tricks => 11)
      assert_equal 0, score.grand_slam_bonus
      score = Bridge::Score.new(:contract => "6S", :vulnerable => true, :tricks => 13)
      assert_equal 0, score.grand_slam_bonus
    end

    it "doubled and redoubled cotract made bonus" do
      score = Bridge::Score.new(:contract => "4SX", :tricks => 10)
      assert_equal 50, score.doubled_bonus
      score = Bridge::Score.new(:contract => "4SXX", :tricks => 10)
      assert_equal 100, score.redoubled_bonus
      assert_equal 0, score.doubled_bonus
    end

    it "vulnerable undertrick points" do
      score = Bridge::Score.new(:contract => "4S", :vulnerable => true, :tricks => 9)
      assert_equal -100, score.vulnerable_undertrick_points
      score = Bridge::Score.new(:contract => "4SX", :vulnerable => true, :tricks => 9)
      assert_equal -200, score.vulnerable_undertrick_points
      score = Bridge::Score.new(:contract => "4SX", :vulnerable => true, :tricks => 7)
      assert_equal -800, score.vulnerable_undertrick_points
      score = Bridge::Score.new(:contract => "4SXX", :vulnerable => true, :tricks => 9)
      assert_equal -400, score.vulnerable_undertrick_points
      score = Bridge::Score.new(:contract => "4SXX", :vulnerable => true, :tricks => 7)
      assert_equal -1600, score.vulnerable_undertrick_points
    end

    it "not vulnerable undertrick points" do
      score = Bridge::Score.new(:contract => "4S", :vulnerable => false, :tricks => 9)
      assert_equal -50, score.not_vulnerable_undertrick_points
      score = Bridge::Score.new(:contract => "4SX", :vulnerable => false, :tricks => 9)
      assert_equal -100, score.not_vulnerable_undertrick_points
      score = Bridge::Score.new(:contract => "4SX", :vulnerable => false, :tricks => 7)
      assert_equal -500, score.not_vulnerable_undertrick_points
      score = Bridge::Score.new(:contract => "4SXX", :vulnerable => false, :tricks => 9)
      assert_equal -200, score.not_vulnerable_undertrick_points
      score = Bridge::Score.new(:contract => "4SXX", :vulnerable => false, :tricks => 7)
      assert_equal -1000, score.not_vulnerable_undertrick_points
      score = Bridge::Score.new(:contract => "4SX", :vulnerable => false, :tricks => 6)
      assert_equal -800, score.not_vulnerable_undertrick_points
      score = Bridge::Score.new(:contract => "4SXX", :vulnerable => false, :tricks => 6)
      assert_equal -1600, score.not_vulnerable_undertrick_points
      score = Bridge::Score.new(:contract => "4S", :vulnerable => false, :tricks => 6)
      assert_equal -200, score.not_vulnerable_undertrick_points
    end

    it "overtrick points" do
      score = Bridge::Score.new(:contract => "2S", :vulnerable => false, :tricks => 10)
      assert_equal 60, score.overtrick_points
      score = Bridge::Score.new(:contract => "2SX", :vulnerable => false, :tricks => 9)
      assert_equal 100, score.overtrick_points
      score = Bridge::Score.new(:contract => "2SXX", :vulnerable => false, :tricks => 9)
      assert_equal 200, score.overtrick_points
      score = Bridge::Score.new(:contract => "2S", :vulnerable => true, :tricks => 9)
      assert_equal 30, score.overtrick_points
      score = Bridge::Score.new(:contract => "2SX", :vulnerable => true, :tricks => 9)
      assert_equal 200, score.overtrick_points
      score = Bridge::Score.new(:contract => "2SXX", :vulnerable => true, :tricks => 9)
      assert_equal 400, score.overtrick_points
    end

    it "return 90 points for 1S=" do
      score = Bridge::Score.new(:contract => "3S", :vulnerable => false, :tricks => 9)
      assert_equal 140, score.points
    end

    it "return 70 points for 2S=" do
      score = Bridge::Score.new(:contract => "2NT", :vulnerable => false, :tricks => 8)
      assert_equal 120, score.points
    end

    it "return 80 points for 2D+2" do
      score = Bridge::Score.new(:contract => "2D", :vulnerable => false, :tricks => 10)
      assert_equal 130, score.points
    end

    it "return 1400 points for 5CXX+1" do
      score = Bridge::Score.new(:contract => "5CXX", :vulnerable => true, :tricks => 12)
      assert_equal 1400, score.points
    end

    it "return 1700 points for 3NTX-7" do
      score = Bridge::Score.new(:contract => "3NTX", :vulnerable => false, :tricks => 2)
      assert_equal -1700, score.points
    end

    it "return -7600 points for 7NTXX-13" do
      score = Bridge::Score.new(:contract => "7NTXX", :vulnerable => true, :tricks => 0)
      assert_equal -7600, score.points
    end

    it "return -7600 points for 7NT-13" do
      score = Bridge::Score.new(:contract => "7NT", :vulnerable => false, :tricks => 0)
      assert_equal -650, score.points
    end

    it "return -1300 points for 7NT-13" do
      score = Bridge::Score.new(:contract => "7NT", :vulnerable => true, :tricks => 0)
      assert_equal -1300, score.points
    end

    it "return -3500 points for 7NTX-13" do
      score = Bridge::Score.new(:contract => "7NTX", :vulnerable => false, :tricks => 0)
      assert_equal -3500, score.points
    end

    it "return -3800 points for 7NTX-13" do
      score = Bridge::Score.new(:contract => "7NTX", :vulnerable => true, :tricks => 0)
      assert_equal -3800, score.points
    end

    it "return -7000 points for 7NTXX-13" do
      score = Bridge::Score.new(:contract => "7NTXX", :vulnerable => false, :tricks => 0)
      assert_equal -7000, score.points
    end

    it "return 1340 points for 1CX+6" do
      score = Bridge::Score.new(:contract => "1CX", :vulnerable => true, :tricks => 13)
      assert_equal 1340, score.points
    end

    it "return 740 points for 1CX+6" do
      score = Bridge::Score.new(:contract => "1CX", :vulnerable => false, :tricks => 13)
      assert_equal 740, score.points
    end
  end

  describe "contracts" do
    it "1764 results" do
      assert_equal 1764, Bridge::Score.all_contracts.size
    end

    it "return contracts for 1430 points" do
      expected = ["1C/DXX+3v", "1C/DXX+6", "6H/S=v"]
      assert_equal expected, Bridge::Score.with_points(1430)
    end

    it "return no contracts if not found score with given points" do
      assert_equal [], Bridge::Score.with_points(100)
    end
  end

  describe "regexp" do
    before do
      @regexp = Bridge::Score::REGEXP
    end

    it "match 1S+1" do
      assert "1S+1" =~ @regexp
    end

    it "match 1NT=" do
      assert "1NT=" =~ @regexp
    end

    it "not match 8S=" do
      assert_nil "8S=" =~ @regexp
    end

    it "not match 1SXXX=" do
      assert_nil "1SXXX=" =~ @regexp
    end

    it "not match 1S+7" do
      assert_nil "1S+7" =~ @regexp
    end

    it "not match 1S-14" do
      assert_nil "1S-14" =~ @regexp
    end

    it "not match 1S-21" do
      assert_nil "1S-21" =~ @regexp
    end

    it "case sensitive" do
      assert_nil "1s-1" =~ @regexp
    end

    it "return contract for 1NT=" do
      result = "1NT=".match(@regexp)
      assert_equal "1NT", RUBY_VERSION >= "1.9" ? result[:contract] : result[1]
    end

    it "return contract for 1NTXX=" do
      result = "1NTXX=".match(@regexp)
      assert_equal "1NTXX", RUBY_VERSION >= "1.9" ? result[:contract] : result[1]
    end

    it "return result for 1NT=" do
      result = "1NT=".match(@regexp)
      assert_equal "=", RUBY_VERSION >= "1.9" ? result[:result] : result[5]
    end

    it "return result for 1NT+2" do
      result = "1NT+2".match(@regexp)
      assert_equal "+2", RUBY_VERSION >= "1.9" ? result[:result] : result[5]
    end
  end
end
