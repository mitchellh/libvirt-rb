require 'test_helper'

Protest.describe("Network IP DHCP spec") do
  setup do
    @klass = Libvirt::Spec::Network::DHCP
  end

  context "initialization and parsing XML" do
    should "parse the ranges" do
      @instance = @klass.new("<dhcp><range start='foo' end='bar'/><range start='baz' end='foo'/></dhcp>")
      assert_equal 2, @instance.ranges.length
    end
  end
end
