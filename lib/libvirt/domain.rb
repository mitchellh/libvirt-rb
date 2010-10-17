module Libvirt
  # Represents a domain within libvirt, which is a single virtual
  # machine or environment, typically.
  class Domain
    attr_reader :domain_pointer

    # TODO: This will support creation one day, so this single
    # mandatory initialization parameter won't fly.
    def initialize(pointer)
      @domain_pointer = pointer
    end

    # Returns the name of the domain as a string.
    #
    # @return [String]
    def name
      FFI::Libvirt.virDomainGetName(domain_pointer)
    end

    # Returns the UUID of the domain as a string.
    #
    # @return [String]
    def uuid
      output_ptr = FFI::MemoryPointer.new(:char, 48)
      FFI::Libvirt.virDomainGetUUIDString(domain_pointer, output_ptr)
      output_ptr.read_string
    end

    # Returns the hypervisor ID number for this domain.
    #
    # @return [Integer]
    def id
      FFI::Libvirt.virDomainGetID(domain_pointer)
    end

    # Returns the current state this domain is in.
    #
    # @return [Symbol]
    def state
      domain_info[:state]
    end

    # Returns the maximum memory (in KB) allowed on this domain.
    #
    # @return [Integer]
    def max_memory
      domain_info[:maxMem]
    end

    # Returns the memory (in KB) currently allocated to this domain.
    #
    # @return [Integer]
    def memory
      domain_info[:memory]
    end

    # Returns the number of virtual CPUs for this domain.
    #
    # @return [Integer]
    def virtual_cpus
      domain_info[:nrVirtCpu]
    end

    # Returns the CPU time used in nanoseconds.
    #
    # @return [Integer]
    def cpu_time_used
      domain_info[:cpuTime]
    end

    # Returns the XML description of this domain.
    #
    # @return [String]
    def xml
      # TODO: The flags in the 2nd parameter
      FFI::Libvirt.virDomainGetXMLDesc(domain_pointer, 0)
    end

    # Returns boolean of whether the domain is active (running) or not.
    #
    # @return [Boolean]
    def active?
      result = FFI::Libvirt.virDomainIsActive(domain_pointer)
      # TODO: Process error, result == -1
      result == 1
    end

    # Returns boolean of whether the domain is persistent, or whether it
    # will still exist after it is shut down.
    #
    # @return [Boolean]
    def persistent?
      result = FFI::Libvirt.virDomainIsPersistent(domain_pointer)
      # TODO: Process error, result == -1
      result == 1
    end

    protected

    # Queries the domain info from libvirt to get standard information
    # about this domain.
    def domain_info
      result = FFI::Libvirt::DomainInfo.new
      FFI::Libvirt.virDomainGetInfo(domain_pointer, result.to_ptr)
      result
    end
  end
end
