module Libvirt
  class Connection
    # Access to the raw virConnectPtr returned by initializing the connection.
    # Use this if you need direct access to the FFI layer.
    attr_reader :pointer

    def self.connect(uri=nil)
      pointer = FFI::Libvirt.virConnectOpen(uri)
      raise Error::ConnectionFailed if pointer.null?
      new(pointer)
    end

    def initialize(pointer)
      @pointer = pointer
    end

    # Returns the capabilities of the connected hypervisor/driver. Returns them
    # as an XML string. This method calls `virConnectGetCapabilities`. This will
    # probably be parsed into a more useful format in the future.
    #
    # @return [String]
    def capabilities
      FFI::Libvirt.virConnectGetCapabilities(pointer)
    end

    # Returns the system hostname on which the hypervisor is running. Therefore,
    # if connected to a remote `libvirtd` daemon, then it will return the hostname
    # of that machine.
    #
    # @return [String]
    def hostname
      FFI::Libvirt.virConnectGetHostname(pointer)
    end

    # Returns the version of `libvirt` which the daemon on the other side is
    # running. If not connected to a remote daemon, it will return the version
    # of libvirt on this machine. The result is an array representatin of the
    # version, as `[major, minor, patch]`.
    #
    # @return [Array]
    def lib_version
      output_ptr = FFI::MemoryPointer.new(:ulong)
      FFI::Libvirt.virConnectGetLibVersion(pointer, output_ptr)
      result = output_ptr.get_ulong(0)

      # Format is MAJOR * 1,000,000 + MINOR * 1,000 + PATCH, so we
      # need to decode it.
      major = result / 1_000_000
      result %= 1_000_000
      minor = result / 1_000
      result %= 1000
      [major, minor, result]
    end
  end
end
