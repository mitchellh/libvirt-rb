module Libvirt
  # Represents a network within libvirt, which is a network interface
  # such as a host-only network for VirtualBox, for example.
  class Network
    # Initializes a new {Network} object given a `virNetworkPtr`. Please
    # do not call this directly. Instead, use the {Connection#networks}
    # object.
    def initialize(pointer)
      @pointer = pointer
      ObjectSpace.define_finalizer(self, method(:finalize))
    end

    # Returns the name of the network as a string.
    #
    # @return [String]
    def name
      FFI::Libvirt.virNetworkGetName(self)
    end

    # Returns the XML descriptions of this network.
    #
    # @return [String]
    def xml
      FFI::Libvirt.virNetworkGetXMLDesc(self, 0)
    end

    # Returns the UUID of the network as a string.
    #
    # @return [String]
    def uuid
      output_ptr = FFI::MemoryPointer.new(:char, 36)
      FFI::Libvirt.virNetworkGetUUIDString(self, output_ptr)
      output_ptr.read_string
    end

    # Deterine if the network is active or not.
    #
    # @return [Boolean]
    def active?
      FFI::Libvirt.virNetworkIsActive(self) == 1
    end

    # Determine if the network is persistent or not.
    #
    # @return [Boolean]
    def persistent?
      FFI::Libvirt.virNetworkIsPersistent(self) == 1
    end

    # Starts a network.
    def create
      FFI::Libvirt.virNetworkCreate(self)
    end
    alias :start :create

    # Stops a network.
    def destroy
      FFI::Libvirt.virNetworkDestroy(self)
    end
    alias :stop :destroy

    # Undefines the network, but will not stop it if it is
    # running.
    def undefine
      FFI::Libvirt.virNetworkUndefine(self)
    end

    # Converts to the actual `virNetworkPtr` of this structure. This allows
    # this object to be used directly with the FFI layer which expects a
    # `virNetworkPtr`.
    #
    # @return [FFI::Pointer]
    def to_ptr
      @pointer
    end

    # Provide a meaningful equality check for two networks by comparing
    # UUID.
    #
    # @return [Boolean]
    def ==(other)
      other.is_a?(Network) && other.uuid == uuid
    end

    protected

    # Cleans up the `virNetworkPtr` and releases the resources associated
    # with it. This is automatically called when this object is garbage
    # collected.
    def finalize(*args)
      FFI::Libvirt.virNetworkFree(self)
    end
  end
end
