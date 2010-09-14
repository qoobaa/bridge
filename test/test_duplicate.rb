require "helper"

class TestDuplicate < Test::Unit::TestCase
  test "maximum points with unique values" do
    maximum = Bridge::Points::Duplicate.new(-200, -100, 620, 630, 660, 690).maximum
    assert_equal 10, maximum[690]
    assert_equal  8, maximum[660]
    assert_equal  6, maximum[630]
    assert_equal  4, maximum[620]
    assert_equal  2, maximum[-100]
    assert_equal  0, maximum[-200]
  end

  test "maximum points with non-unique values" do
    maximum = Bridge::Points::Duplicate.new(420, 420, 400, 400, -50, -100).maximum
    assert_equal 9, maximum[420]
    assert_equal 5, maximum[400]
    assert_equal 2, maximum[-50]
    assert_equal 0, maximum[-100]
  end

  test "maximum points with non-unique values, without zero value" do
    maximum = Bridge::Points::Duplicate.new(430, 420, 420, 420, 300, 300).maximum
    assert_equal 10, maximum[430]
    assert_equal  6, maximum[420]
    assert_equal  1, maximum[300]
  end

  test "maximum percents with non-unique values" do
    maximum_in_percents = Bridge::Points::Duplicate.new(-630, 100, 100, -600, 200, -600, 100, 100, 100, -600, 100, 100, 100, 100).maximum_in_percents(1)
    assert_equal 100.0, maximum_in_percents[200]
    assert_equal  61.5, maximum_in_percents[100]
    assert_equal  15.4, maximum_in_percents[-600]
    assert_equal   0.0, maximum_in_percents[-630]
  end

  test "maximum percents with unique-values" do
    maximum_in_percents = Bridge::Points::Duplicate.new(200, 170, 500, 430, 550, 420).maximum_in_percents(2)
    assert_equal 100.0, maximum_in_percents[550]
    assert_equal  80.0, maximum_in_percents[500]
    assert_equal  60.0, maximum_in_percents[430]
    assert_equal  40.0, maximum_in_percents[420]
    assert_equal  20.0, maximum_in_percents[200]
    assert_equal   0.0, maximum_in_percents[170]
  end

  test "butler with skipping the highest and the lowest score" do
    butler = Bridge::Points::Duplicate.new(690, 660, 630, 620, -100, -200).butler
    assert_equal   6, butler[690]
    assert_equal   5, butler[660]
    assert_equal   5, butler[630]
    assert_equal   5, butler[620]
    assert_equal -11, butler[-100]
    assert_equal -12, butler[-200]
  end

  test "cavendish with unique values" do
    cavendish = Bridge::Points::Duplicate.new(690, 660, 630, 620, -100, -200).cavendish
    assert_equal   6.2, cavendish[690]
    assert_equal   5.4, cavendish[660]
    assert_equal   4.4, cavendish[630]
    assert_equal   4.4, cavendish[620]
    assert_equal  -9.4, cavendish[-100]
    assert_equal -11.0, cavendish[-200]
  end

  test "cavendish with non-unique values" do
    cavendish = Bridge::Points::Duplicate.new(100, 100, 110, 140).cavendish
    assert_equal  1.0, cavendish[140]
    assert_equal -0.3, cavendish[110]
    assert_equal -0.3, cavendish[100]
  end
end
