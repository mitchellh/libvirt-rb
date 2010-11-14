require "test_helper"

Protest.describe("node device") do
  setup do
    @klass = Libvirt::NodeDevice
    @instance = Libvirt.connect("test:///default").node.devices.first
  end

  should "provide the name" do
    assert_equal "computer", @instance.name
  end

  should "provide the XML description" do
    assert @instance.xml
  end
end
