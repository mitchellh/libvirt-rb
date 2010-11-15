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

  should "be able to create a node device" do
    assert_raises(Libvirt::Exception::LibvirtError) {
      @instance.create(<<-XML)
<device>
  <name>computer2</name>
</device>
XML
    }
  end
end
