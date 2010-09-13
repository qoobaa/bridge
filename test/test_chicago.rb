require "helper"

class TestChicago < Test::Unit::TestCase
  test "raises ArgumentError when invalid honour card points provided" do
    assert_raises(ArgumentError) do
      Bridge::Points::Chicago.new(:hcp => 15, :points => 100)
    end
  end

  test "set default vulnerable to false" do
    imp = Bridge::Points::Chicago.new(:hcp => 40, :points => -100)
    assert_false imp.vulnerable
  end

  test "return vulnerable boolean" do
    imp = Bridge::Points::Chicago.new(:hcp => 20, :points => 100, :vulnerable => true)
    assert imp.vulnerable?
  end

  test "return points to make when vulnerable" do
    imp = Bridge::Points::Chicago.new(:hcp => 23, :points => 100, :vulnerable => true)
    assert_equal 110, imp.points_to_make
  end

  test "return nil when points are not in range" do
    imp = Bridge::Points::Chicago.new(:hcp => 20, :points => 45)
    assert_equal nil, imp.imps
  end

  test "return high value of imp range" do
    imp = Bridge::Points::Chicago.new(:hcp => 22, :points => 110)
    assert_equal 1, imp.imps
  end

  test "return points to make when not vulnerable" do
    imp = Bridge::Points::Chicago.new(:hcp => 23, :points => 100, :vulnerable => false)
    assert_equal 110, imp.points_to_make
  end

  test "return positive imps" do
    imp = Bridge::Points::Chicago.new(:hcp => 21, :points => 100)
    assert_equal 2, imp.imps
  end

  test "return negative imps" do
    imp = Bridge::Points::Chicago.new(:hcp => 21, :points => -100)
    assert_equal -4, imp.imps
  end
end
