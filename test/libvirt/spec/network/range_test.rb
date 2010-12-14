require 'test_helper'

Protest.describe("Network DHCP Range spec") do
  setup do
    @klass = Libvirt::Spec::Network::Range
  end

  context "initialization and parsing XML" do
    should "parse the start" do
      @instance = @klass.new("<range start='foo'/>")
      assert_equal "foo", @instance.start
    end

    should "parse the end" do
      @instance = @klass.new("<range end='bar'/>")
      assert_equal "bar", @instance.end
    end
  end
end
