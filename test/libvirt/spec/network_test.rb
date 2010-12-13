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
  end
end
