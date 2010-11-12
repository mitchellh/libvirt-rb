module Libvirt
  # Describes a connection to an instance of libvirt. This instance may be local
  # or remote.
  #
  # # Initiating a Connection
  #
  # ## Basic
  #
  # A basic example of initiating a connection is to just allow the libvirt client
  # library to choose the best (first available) hypervisor for you. If you're only
  # running one hypervisor or you're not sure what is available on your machine,
  # then this is the easiest option to get started:
  #
  #     conn = Libvirt::Connection.connect
  #
  # ## Specifying a URI
  #
  # Libvirt connections are made by giving a URI to libvirt, which can describe
  # a local or remote libvirt instance (remote being that `libvirtd` is running).
  # The following is an example of a local VirtualBox connection:
  #
  #     conn = Libvirt::Connection.connect("vbox:///session")
  #
  # And perhaps a remote qemu connection:
  #
  #     conn = Libvirt::Connection.connect("qemu+tcp://10.0.0.1/system")
  #
  # # Basic Information of a Connection
  #
  # Once you have a connection object, you can gather basic information about it
  # by using methods such as {#name}, {#capabilities}, etc.:
  #
  #     puts "Hypervisor type: #{conn.hypervisor}"
  #     puts "Hypervisor version: #{conn.hypervisor_verison}"
  #     puts "Library version: #{conn.lib_version}"
  #
  class Connection
    # Opens a new connection to libvirt. This connection may be local or remote.
    # If a `uri` is given, an attempt to connect to the given URI is made. The URI
    # can be used to specify the location of libvirt along with the hypervisor
    # to connect to.
    #
    # @param [String] uri
    def initialize(uri=nil)
      @pointer = FFI::Libvirt.virConnectOpen(uri)
      ObjectSpace.define_finalizer(self, method(:finalize))
    end

    # Returns the domains (both active and inactive) related to this
    # connection. The various states of the domains returned can be
    # queried using {Domain#state}.
    #
    # @return [Collection::DomainCollection]
    def domains
      Collection::DomainCollection.new(self)
    end

    # Returns the interfaces (both active and inactive) related to this
    # connection.
    #
    # @return [Collection::InterfaceCollection]
    def interfaces
      Collection::InterfaceCollection.new(self)
    end

    # Returns the networks related to this connection.
    #
    # @return [Collection::NetworkCollection]
    def networks
      Collection::NetworkCollection.new(self)
    end

    # Returns the capabilities of the connected hypervisor/driver. Returns them
    # as an XML string. This method calls `virConnectGetCapabilities`. This will
    # probably be parsed into a more useful format in the future.
    #
    # @return [String]
    def capabilities
      FFI::Libvirt.virConnectGetCapabilities(self)
    end

    # Returns the system hostname on which the hypervisor is running. Therefore,
    # if connected to a remote `libvirtd` daemon, then it will return the hostname
    # of that machine.
    #
    # @return [String]
    def hostname
      FFI::Libvirt.virConnectGetHostname(self)
    end

    # Returns the URI of the connection.
    #
    # @return [String]
    def uri
      FFI::Libvirt.virConnectGetURI(self)
    end

    # Returns the name of the hypervisor. This is named "type" since that is the
    # terminology which libvirt itself uses. This is also aliased as `hypervisor`
    # since that is more friendly.
    #
    # @return [String]
    def type
      FFI::Libvirt.virConnectGetType(self)
    end
    alias :hypervisor :type

    # Returns the version of the hypervisor. This version is returned as an array
    # representation as `[major, minor, patch]`.
    #
    # @return [Array]
    def hypervisor_version
      output_ptr = FFI::MemoryPointer.new(:ulong)
      FFI::Libvirt.virConnectGetVersion(self, output_ptr)
      FFI::Libvirt::Util.parse_version_number(output_ptr.get_ulong(0))
    end

    # Returns the version of `libvirt` which the daemon on the other side is
    # running. If not connected to a remote daemon, it will return the version
    # of libvirt on this machine. The result is an array representatin of the
    # version, as `[major, minor, patch]`.
    #
    # @return [Array]
    def lib_version
      output_ptr = FFI::MemoryPointer.new(:ulong)
      FFI::Libvirt.virConnectGetLibVersion(self, output_ptr)
      FFI::Libvirt::Util.parse_version_number(output_ptr.get_ulong(0))
    end

    # Provides the pointer of the connection. This allows this object to be
    # used directly with the FFI layer, as if this object were actually
    # a `virConnectPtr`.
    #
    # @return [FFI::Pointer]
    def to_ptr
      @pointer
    end

    protected

    # Cleans up the connection by releasing the connection object. This
    # never needs to be called directly since there is a finalizer on
    # this object to clean the connection. Therefore, to close the connection,
    # simply release the reference to the connection.
    def finalize(*args)
      FFI::Libvirt.virConnectClose(self) rescue nil
    end
  end
end
