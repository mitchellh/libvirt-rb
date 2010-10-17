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
