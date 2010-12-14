require 'test_helper'

Protest.describe("Network IP spec") do
  setup do
    @klass = Libvirt::Spec::Network::IP
  end

  context "initialization and parsing XML" do
    should "parse the address" do
      @instance = @klass.new("<ip address='foo'/>")
      assert_equal "foo", @instance.address
    end

    should "parse the netmask" do
      @instance = @klass.new("<ip netmask='bar'/>")
      assert_equal "bar", @instance.netmask
    end
  end
end
