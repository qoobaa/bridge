require "helper"

describe Bridge::Score do
  before do
    @score = Bridge::Score.new("1SN", "NONE", 9)
  end

  it "return made contract?" do
    score = Bridge::Score.new("6SN", "NONE", 9)
    refute score.made?
    score = Bridge::Score.new("3NTN", "NONE", 3)
    refute score.made?
    score = Bridge::Score.new("7NTN", "NONE", 13)
    assert score.made?
    score = Bridge::Score.new("3NTN", "NONE", 11)
    assert score.made?
  end

  it "return vulnerable" do
    score = Bridge::Score.new("6SN", "BOTH", 12)
    assert score.vulnerable?
    score = Bridge::Score.new("6SN", "EW", 12)
    refute score.vulnerable?
  end

  it "return result" do
    assert_equal 2, @score.result
    score = Bridge::Score.new("6SN", "NONE", 12)
    assert_equal 0, score.result
    score = Bridge::Score.new("6SN", "NONE", 10)
    assert_equal -2, score.result
  end

  it "return result string" do
    assert_equal "+2", @score.result_string
    score = Bridge::Score.new("6SN", "NONE", 12)
    assert_equal "=", score.result_string
    score = Bridge::Score.new("6SN", "NONE", 10)
    assert_equal "-2", score.result_string
  end

  it "calculate tricks with plus" do
    score = Bridge::Score.new("4SN", "NONE", "+1")
    assert_equal 11, score.tricks_number
  end

  it "calculate tricks with minus" do
    score = Bridge::Score.new("4SN", "NONE", "-4")
    assert_equal 6, score.tricks_number
  end

  it "calculate tricks with equal sign" do
    score = Bridge::Score.new("4SN", "NONE", "=")
    assert_equal 10, score.tricks_number
  end

  describe "points" do
    it "game bonus" do
      score = Bridge::Score.new("3SN", "NONE", 9)
      assert_equal 140, score.points
      score = Bridge::Score.new("4SN", "NONE", 10)
      assert_equal 420, score.points
      score = Bridge::Score.new("3NTN", "BOTH", 9)
      assert_equal 600, score.points
    end

    it "small slam bonus" do
      score = Bridge::Score.new("6SN", "NONE", 12)
      assert_equal 980, score.points
      score = Bridge::Score.new("6SN", "BOTH", 12)
      assert_equal 1430, score.points
    end

    it "grand slam bonus" do
      score = Bridge::Score.new("7SN", "NONE", 13)
      assert_equal 1510, score.points
      score = Bridge::Score.new("7SN", "BOTH", 13)
      assert_equal 2210, score.points
    end

    it "doubled and redoubled cotract made bonus" do
      score = Bridge::Score.new("4SXN", "NONE", 10)
      assert_equal 590, score.points
      score = Bridge::Score.new("4SXXN", "NONE", 10)
      assert_equal 880, score.points
    end

    it "vulnerable undertrick points" do
      score = Bridge::Score.new("4SN", "BOTH", 9)
      assert_equal -100, score.points
      score = Bridge::Score.new("4SXN", "BOTH", 9)
      assert_equal -200, score.points
      score = Bridge::Score.new("4SXN", "BOTH", 7)
      assert_equal -800, score.points
      score = Bridge::Score.new("4SXXN", "BOTH", 9)
      assert_equal -400, score.points
      score = Bridge::Score.new("4SXXN", "BOTH", 7)
      assert_equal -1600, score.points
    end

    it "not vulnerable undertrick points" do
      score = Bridge::Score.new("4SN", "NONE", 9)
      assert_equal -50, score.points
      score = Bridge::Score.new("4SXN", "NONE", 9)
      assert_equal -100, score.points
      score = Bridge::Score.new("4SXN", "NONE", 7)
      assert_equal -500, score.points
      score = Bridge::Score.new("4SXXN", "NONE", 9)
      assert_equal -200, score.points
      score = Bridge::Score.new("4SXXN", "NONE", 7)
      assert_equal -1000, score.points
      score = Bridge::Score.new("4SXN", "NONE", 6)
      assert_equal -800, score.points
      score = Bridge::Score.new("4SXXN", "NONE", 6)
      assert_equal -1600, score.points
      score = Bridge::Score.new("4SN", "NONE", 6)
      assert_equal -200, score.points
    end

    it "overtrick points" do
      score = Bridge::Score.new("2SN", "NONE", 10)
      assert_equal 170, score.points
      score = Bridge::Score.new("2SXN", "NONE", 9)
      assert_equal 570, score.points
      score = Bridge::Score.new("2SXXN", "NONE", 9)
      assert_equal 840, score.points
      score = Bridge::Score.new("2SN", "BOTH", 9)
      assert_equal 140, score.points
      score = Bridge::Score.new("2SXN", "BOTH", 9)
      assert_equal 870, score.points
      score = Bridge::Score.new("2SXXN", "BOTH", 9)
      assert_equal 1240, score.points
    end

    it "return 90 points for 1S=" do
      score = Bridge::Score.new("3SN", "NONE", 9)
      assert_equal 140, score.points
    end

    it "return 70 points for 2S=" do
      score = Bridge::Score.new("2NTN", "NONE", 8)
      assert_equal 120, score.points
    end

    it "return 80 points for 2D+2" do
      score = Bridge::Score.new("2DN", "NONE", 10)
      assert_equal 130, score.points
    end

    it "return 1400 points for 5CXX+1" do
      score = Bridge::Score.new("5CXXN", "BOTH", 12)
      assert_equal 1400, score.points
    end

    it "return 1700 points for 3NTX-7" do
      score = Bridge::Score.new("3NTXN", "NONE", 2)
      assert_equal -1700, score.points
    end

    it "return -7600 points for 7NTXX-13" do
      score = Bridge::Score.new("7NTXXN", "BOTH", 0)
      assert_equal -7600, score.points
    end

    it "return -7600 points for 7NT-13" do
      score = Bridge::Score.new("7NTN", "NONE", 0)
      assert_equal -650, score.points
    end

    it "return -1300 points for 7NT-13" do
      score = Bridge::Score.new("7NTN", "BOTH", 0)
      assert_equal -1300, score.points
    end

    it "return -3500 points for 7NTX-13" do
      score = Bridge::Score.new("7NTXN", "NONE", 0)
      assert_equal -3500, score.points
    end

    it "return -3800 points for 7NTX-13" do
      score = Bridge::Score.new("7NTXN", "BOTH", 0)
      assert_equal -3800, score.points
    end

    it "return -7000 points for 7NTXX-13" do
      score = Bridge::Score.new("7NTXXN", "NONE", 0)
      assert_equal -7000, score.points
    end

    it "return 1340 points for 1CX+6" do
      score = Bridge::Score.new("1CXN", "BOTH", 13)
      assert_equal 1340, score.points
    end

    it "return 740 points for 1CX+6" do
      score = Bridge::Score.new("1CXN", "NONE", 13)
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
end
