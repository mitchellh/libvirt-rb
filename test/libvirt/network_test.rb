require "test_helper"

Protest.describe("network") do
  setup do
    @klass = Libvirt::Network
    @instance = Libvirt.connect("test:///default").networks.all.first
  end

  should "provide the name of the network" do
    result = @instance.name
    assert result
  end

  should "provide the UUID of the network" do
    result = @instance.uuid
    assert result
    assert_equal 36, result.length
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
