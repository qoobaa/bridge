require 'rubygems'
gem "test-unit"
require 'test/unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'bridge'

class Test::Unit::TestCase

end
