require 'test_helper'

Protest.describe("Network spec") do
  setup do
    @klass = Libvirt::Spec::Network
  end

  context "initialization with XML parsing" do
    should "parse the name" do
      @instance = @klass.new("<network><name>foo</name></network>")
      assert_equal "foo", @instance.name
    end

    should "parse the UUID" do
      @instance = @klass.new("<network><uuid>foo</uuid></network>")
      assert_equal "foo", @instance.uuid
    end

    should "parse the bridge connection" do
      @instance = @klass.new("<network><bridge delay='7' /></network>")
      assert_equal 7, @instance.bridge.delay
    end
  end
end
