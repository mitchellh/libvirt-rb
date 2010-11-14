require "test_helper"

Protest.describe("node device collection") do
  setup do
    @klass = Libvirt::Collection::NodeDeviceCollection
    @instance = Libvirt.connect("test:///default").node.devices
  end

  should "provide access to all nodes" do
    result = nil
    assert_nothing_raised { result = @instance.all }
    assert result
  end
end
