require "helper"

describe Bridge::Points::Duplicate do
  it "maximum points with unique values" do
    maximum = Bridge::Points::Duplicate.new(-200, -100, 620, 630, 660, 690).maximum
    assert_equal 10, maximum[690]
    assert_equal  8, maximum[660]
    assert_equal  6, maximum[630]
    assert_equal  4, maximum[620]
    assert_equal  2, maximum[-100]
    assert_equal  0, maximum[-200]
  end

  it "maximum points with non-unique values" do
    maximum = Bridge::Points::Duplicate.new(420, 420, 400, 400, -50, -100).maximum
    assert_equal 9, maximum[420]
    assert_equal 5, maximum[400]
    assert_equal 2, maximum[-50]
    assert_equal 0, maximum[-100]
  end

  it "maximum points with non-unique values, without zero value" do
    maximum = Bridge::Points::Duplicate.new(430, 420, 420, 420, 300, 300).maximum
    assert_equal 10, maximum[430]
    assert_equal  6, maximum[420]
    assert_equal  1, maximum[300]
  end

  it "maximum percents with non-unique values" do
    maximum_in_percents = Bridge::Points::Duplicate.new(-630, 100, 100, -600, 200, -600, 100, 100, 100, -600, 100, 100, 100, 100).maximum_in_percents
    assert_in_delta 100.0, maximum_in_percents[200], 0.05
    assert_in_delta  61.5, maximum_in_percents[100], 0.05
    assert_in_delta  15.4, maximum_in_percents[-600], 0.05
    assert_in_delta   0.0, maximum_in_percents[-630], 0.05
  end

  it "maximum percents with unique-values" do
    maximum_in_percents = Bridge::Points::Duplicate.new(200, 170, 500, 430, 550, 420).maximum_in_percents
    assert_in_delta 100.0, maximum_in_percents[550], 0.005
    assert_in_delta  80.0, maximum_in_percents[500], 0.005
    assert_in_delta  60.0, maximum_in_percents[430], 0.005
    assert_in_delta  40.0, maximum_in_percents[420], 0.005
    assert_in_delta  20.0, maximum_in_percents[200], 0.005
    assert_in_delta   0.0, maximum_in_percents[170], 0.005
  end

  it "butler with skipping the highest and the lowest score" do
    butler = Bridge::Points::Duplicate.new(690, 660, 630, 620, -100, -200).butler
    assert_equal   6, butler[690]
    assert_equal   5, butler[660]
    assert_equal   5, butler[630]
    assert_equal   5, butler[620]
    assert_equal -11, butler[-100]
    assert_equal -12, butler[-200]
  end

  it "cavendish with unique values" do
    cavendish = Bridge::Points::Duplicate.new(690, 660, 630, 620, -100, -200).cavendish
    assert_in_delta   6.2, cavendish[690], 0.05
    assert_in_delta   5.4, cavendish[660], 0.05
    assert_in_delta   4.4, cavendish[630], 0.05
    assert_in_delta   4.4, cavendish[620], 0.05
    assert_in_delta  -9.4, cavendish[-100], 0.05
    assert_in_delta -11.0, cavendish[-200], 0.05
  end

  it "cavendish with non-unique values" do
    cavendish = Bridge::Points::Duplicate.new(100, 100, 110, 140).cavendish
    assert_in_delta  1.0, cavendish[140], 0.05
    assert_in_delta -0.3, cavendish[110], 0.05
    assert_in_delta -0.3, cavendish[100], 0.05
  end
end
