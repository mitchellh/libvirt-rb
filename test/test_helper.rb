require "test/unit/assertions"
require "protest"
require "libvirt"

class Protest::TestCase
  include Test::Unit::Assertions
end

Protest.report_with(:turn)
