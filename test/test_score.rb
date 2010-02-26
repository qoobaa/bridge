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