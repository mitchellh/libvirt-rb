require 'test_helper'

Protest.describe("Network DHCP host spec") do
  setup do
    @klass = Libvirt::Spec::Network::Host
  end

  context "initialization and parsing XML" do
    should "parse the mac address" do
      @instance = @klass.new("<host mac='foo'/>")
      assert_equal "foo", @instance.mac
    end

    should "parse the name" do
      @instance = @klass.new("<host name='bar'/>")
      assert_equal "bar", @instance.name
    end

    should "parse the IP" do
      @instance = @klass.new("<host ip='baz'/>")
      assert_equal "baz", @instance.ip
    end
  end
end
