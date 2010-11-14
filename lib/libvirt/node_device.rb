module Libvirt
  # Represents a device on a node.
  class NodeDevice
    # Initializes a node device with the given `virNodeDevicePtr`. This
    # should not be called directly. Instead, call {Node#devices} to get
    # a list of the devices.
    #
    # @param [FFI::Pointer] pointer
    def initialize(pointer)
      @pointer = pointer
      ObjectSpace.define_finalizer(self, method(:finalize))
    end

    # Returns the name of this device.
    #
    # @return [String]
    def name
      FFI::Libvirt.virNodeDeviceGetName(self)
    end

    # Returns the XML specification for this device.
    #
    # @return [String]
    def xml
      FFI::Libvirt.virNodeDeviceGetXMLDesc(self, 0)
    end

    # Detaches the device from the node itself so that it may be bound to
    # a guest domain.
    #
    # @return [Boolean]
    def dettach
      FFI::Libvirt.virNodeDeviceDettach(self) == 0
    end

    # Reattach the device onto the node.
    #
    # @return [Boolena]
    def reattach
      FFI::Libvirt.virNodeDeviceReAttach(self) == 0
    end

    # Reset the device. The exact semantics of this method are hypervisor
    # specific.
    #
    # @return [Boolena]
    def reset
      FFI::Libvirt.virNodeDeviceReset(self) == 0
    end

    # Destroy the device, removing the virtual device from the host operating
    # system.
    #
    # @return [Boolean]
    def destroy
      FFI::Libvirt.virNodeDeviceDestroy(self) == 0
    end

    # Returns the underlying `virNodeDevicePtr`. This allows this object to
    # be used directly with FFI methods.
    #
    # @return [FFI::Pointer]
    def to_ptr
      @pointer
    end

    protected

    # Frees the underlying resources of the node device. This is called
    # automatically when this object is garbage collected.
    def finalize
      FFI::Libvirt.virNodeDeviceFree(self)
    end
  end
end
