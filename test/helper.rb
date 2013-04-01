require "minitest/autorun"

require "bridge"

class MiniTest::Unit::TestCase
  def assert_false(expected, message = nil)
    assert_equal(false, expected, message)
  end
end
