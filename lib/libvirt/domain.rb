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
