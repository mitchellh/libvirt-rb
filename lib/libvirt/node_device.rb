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
