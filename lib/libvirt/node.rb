module Libvirt
  # Represents a node which libvirt resides on.
  class Node
    # Initializes a node object with the given {Connection} pointer. This
    # shouldn't be called directly. Instead, retrieve the node using
    # {Connection#node}.
    def initialize(pointer)
      # This pointer can either be a `virConnectPtr` directly or a
      # {Connection} since it implements `to_ptr`.
      @pointer = pointer

      # We increase the reference count on the connection while this
      # node object is in use.
      FFI::Libvirt.virConnectRef(connection)

      # Register finalizer for reference cleanup
      ObjectSpace.define_finalizer(self, method(:finalize))
    end

    # Returns the connection this node belongs to as a {Connection}
    # object.
    #
    # @return [Connection]
    def connection
      @connection ||= @pointer.is_a?(Connection) ? @pointer : Connection.new(@pointer)
    end

    # Returns the free memory available on the node. This is returned
    # in bytes.
    #
    # @return [Integer]
    def free_memory
      FFI::Libvirt.virNodeGetFreeMemory(connection)
    end

    # Returns the CPU model of the node.
    #
    # @return [String]
    def cpu_model
      info[:model]
    end

    # Returns the memory size in kilobytes.
    #
    # @return [Integer]
    def memory
      info[:memory]
    end

    # Returns the number of active CPUs.
    #
    # @return [Integer]
    def cpus
      info[:cpus]
    end

    # Returns the expected CPU frequency in MHz.
    #
    # @return [Integer]
    def mhz
      info[:mhz]
    end

    # Returns the number of NUMA cell, 1 for uniform memory access.
    #
    # @return [Integer]
    def nodes
      info[:nodes]
    end

    # Returns the number of CPU sockets per node.
    #
    # @return [Integer]
    def sockets
      info[:sockets]
    end

    # Returns the number of cores per socket.
    #
    # @return [Integer]
    def cores
      info[:cores]
    end

    # Returns the number of threads per core.
    #
    # @return [Integer]
    def threads
      info[:threads]
    end

    protected

    # Returns the {FFI::Libvirt::NodeInfo} structure associated with this
    # node. The various fields of this structure are accessed using the
    # other methods in this class.
    #
    # @return [FFI::Libvirt::NodeInfo]
    def info
      result = FFI::Libvirt::NodeInfo.new
      FFI::Libvirt.virNodeGetInfo(connection, result.to_ptr)
      result
    end

    # Releases the reference to the underlying connection structure.
    # This is automatically called when the object is garbage collected.
    def finalize
      FFI::Libvirt.virConnectFree(connection)
    end
  end
end
