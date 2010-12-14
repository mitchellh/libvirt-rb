require 'test_helper'

Protest.describe("Network bridge spec") do
  setup do
    @klass = Libvirt::Spec::Network::Bridge
  end

  context "initialization and parsing XML" do
    should "parse the name" do
      @instance = @klass.new("<bridge name='foo'/>")
      assert_equal "foo", @instance.name
    end

    should "parse the STP boolean value" do
      @instance = @klass.new("<bridge stp='on'/>")
      assert_equal true, @instance.stp

      @instance = @klass.new("<bridge stp='off'/>")
      assert_equal false, @instance.stp
    end

    should "parse the delay" do
      @instance = @klass.new("<bridge delay='12'/>")
      assert_equal 12, @instance.delay
    end
  end

  context "with an instance" do
    setup do
      @instance = @klass.new("<bridge name='foo' stp='on' delay='7'/>")
    end

    should "set everything to nil on clear" do
      @instance.clear
      assert_nil @instance.name
      assert_nil @instance.stp
      assert_nil @instance.delay
    end
  end
end
