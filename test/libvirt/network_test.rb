require "test_helper"

Protest.describe("network") do
  setup do
    @klass = Libvirt::Network

    @data = {
      :name => "vboxnet0",
      :uuid => "786f6276-656e-4074-8000-0a0027000000"
    }

    @conn = Libvirt.connect("test:///default")
    @instance = @klass.new(FFI::Libvirt.virNetworkDefineXML(@conn, <<-XML))
<network>
  <name>#{@data[:name]}</name>
  <uuid>#{@data[:uuid]}</uuid>
</network>
XML
  end

  should "provide the name of the network" do
    result = @instance.name
    assert_equal @data[:name], result
  end

  should "provide the UUID of the network" do
    result = @instance.uuid
    assert result
    assert_equal @data[:uuid], result
  end

  should "provide the bridge of the network" do
    assert_raise(Libvirt::Exception::LibvirtError) { @instance.bridge }
  end

  should "control autostart" do
    assert !@instance.autostart?
    @instance.autostart = true
    assert @instance.autostart?
  end

  should "provide an active check" do
    assert !@instance.active?
    @instance.start
    assert @instance.active?
  end

  should "provide a persistence check" do
    assert @instance.persistent?
    # TODO: Check state change. Not sure how to trigger this at the moment.
  end

  should "provide ability to stop network" do
    @instance.start
    assert @instance.active?
    @instance.stop
    assert !@instance.active?
  end

  should "be able to undefine the network" do
    assert @conn.networks.include?(@instance)
    @instance.undefine
    assert !@conn.networks.include?(@instance)
  end

  should "provide an equality comparison based on UUID" do
    # TODO: Create multiple networks with uuids to compare
  end

  should "provide a `to_ptr` method to get the `virNetworkPtr`" do
    result = nil
    assert_nothing_raised { result = @instance.to_ptr }
    assert result.is_a?(FFI::Pointer)
    assert !result.null?
  end
end
