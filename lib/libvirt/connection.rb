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
    # Access to the raw virConnectPtr returned by initializing the connection.
    # Use this if you need direct access to the FFI layer.
    attr_reader :pointer

    def self.connect(uri=nil)
      pointer = FFI::Libvirt.virConnectOpen(uri)
      return nil if pointer.null?
      new(pointer)
    end

    def initialize(pointer)
      @pointer = pointer
    end

    # Returns the domains (both active and inactive) related to this
    # connection. The various states of the domains returned can be
    # queried using {Domain#state}.
    #
    # @return [Array<Domain>]
    def domains
      # First get the names of all the inactive domains
      max_names = FFI::Libvirt.virConnectNumOfDefinedDomains(pointer)
      output_ptr = FFI::MemoryPointer.new(:pointer, max_names)
      num_names = FFI::Libvirt.virConnectListDefinedDomains(pointer, output_ptr, max_names)
      inactive_names = output_ptr.get_array_of_string(0, num_names)

      # Then get the IDs of all the active domains
      max_names = FFI::Libvirt.virConnectNumOfDomains(pointer)
      output_ptr = FFI::MemoryPointer.new(:pointer, max_names)
      num_names = FFI::Libvirt.virConnectListDomains(pointer, output_ptr, max_names)
      active_ids = output_ptr.get_array_of_int(0, num_names)

      # Take the names and IDs (why does libvirt do this to me) and return
      # useful {Domain} objects.
      domains = inactive_names + active_ids
      domains.collect do |id|
        method = id.is_a?(String) ? :virDomainLookupByName : :virDomainLookupByID
        domain_ptr = FFI::Libvirt.send(method, pointer, id)
        domain_ptr.null? ? nil : Domain.new(domain_ptr)
      end
    end

    # Defines a new domain given a valid specification. This method doesn't
    # start the domain.
    #
    # @param [Spec::Domain]
    # @return [Domain]
    def define_domain(spec)
      domain_ptr = FFI::Libvirt.virDomainDefineXML(pointer, spec.to_xml)
      domain_ptr.null? ? nil : Domain.new(domain_ptr)
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

    # Returns the URI of the connection.
    #
    # @return [String]
    def uri
      FFI::Libvirt.virConnectGetURI(pointer)
    end

    # Returns the name of the hypervisor. This is named "type" since that is the
    # terminology which libvirt itself uses. This is also aliased as `hypervisor`
    # since that is more friendly.
    #
    # @return [String]
    def type
      FFI::Libvirt.virConnectGetType(pointer)
    end
    alias :hypervisor :type

    # Returns the version of the hypervisor. This version is returned as an array
    # representation as `[major, minor, patch]`.
    #
    # @return [Array]
    def hypervisor_version
      output_ptr = FFI::MemoryPointer.new(:ulong)
      FFI::Libvirt.virConnectGetVersion(pointer, output_ptr)
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
      FFI::Libvirt.virConnectGetLibVersion(pointer, output_ptr)
      FFI::Libvirt::Util.parse_version_number(output_ptr.get_ulong(0))
    end
  end
end
