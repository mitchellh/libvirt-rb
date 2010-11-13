module Libvirt
  # Represents a domain within libvirt, which is a single virtual
  # machine or environment, typically.
  class Domain
    # Initializes a new {Domain} object. If you're calling this directly,
    # omit the `pointer` argument, since that is meant for internal use.
    def initialize(pointer=nil)
      @pointer = pointer if pointer.is_a?(FFI::Pointer)
      ObjectSpace.define_finalizer(self, method(:finalize))
    end

    # Returns the name of the domain as a string.
    #
    # @return [String]
    def name
      FFI::Libvirt.virDomainGetName(self)
    end

    # Returns the UUID of the domain as a string.
    #
    # @return [String]
    def uuid
      output_ptr = FFI::MemoryPointer.new(:char, 36)
      FFI::Libvirt.virDomainGetUUIDString(self, output_ptr)
      output_ptr.read_string
    end

    # Returns the hypervisor ID number for this domain.
    #
    # @return [Integer]
    def id
      FFI::Libvirt.virDomainGetID(self)
    end

    # Returns the OS type of the domain.
    #
    # @return [String]
    def os_type
      FFI::Libvirt.virDomainGetOSType(self)
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

    # Sets the maximum memory (in KB) allowed on this domain.
    #
    # @return [Boolean] Success of the command.
    def max_memory=(value)
      FFI::Libvirt.virDomainSetMaxMemory(self, value) == 0
    end

    # Returns the memory (in KB) currently allocated to this domain.
    #
    # @return [Integer]
    def memory
      domain_info[:memory]
    end

    # Sets the memory (in KB) on an active domain.
    #
    # @return [Boolean] Success of the command.
    def memory=(value)
      FFI::Libvirt.virDomainSetMemory(self, value) == 0
    end

    # Returns the number of virtual CPUs for this domain.
    #
    # @return [Integer]
    def virtual_cpus
      domain_info[:nrVirtCpu]
    end

    # Sets the number of virtual CPUs for this domain.
    #
    # @return [Boolean] Success of the command.
    def virtual_cpus=(value)
      FFI::Libvirt.virDomainSetVcpus(self, value) == 0
    end

    # Returns the maximum number of virtual CPUs supported for this guest
    # VM.
    #
    # @return [Integer]
    def max_virtual_cpus
      FFI::Libvirt.virDomainGetMaxVcpus(self)
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
      FFI::Libvirt.virDomainGetXMLDesc(self, 0)
    end

    # Returns boolean of whether the domain is active (running) or not.
    #
    # @return [Boolean]
    def active?
      result = FFI::Libvirt.virDomainIsActive(self)
      return nil if result == -1
      result == 1
    end

    # Returns boolean of whether the domain is persistent, or whether it
    # will still exist after it is shut down.
    #
    # @return [Boolean]
    def persistent?
      result = FFI::Libvirt.virDomainIsPersistent(self)
      return nil if result == -1
      result == 1
    end

    # Returns boolean of whether the domain autostarts on boot.
    #
    # @return [Boolean]
    def autostart?
      output_ptr = FFI::MemoryPointer.new(:int)
      return nil if FFI::Libvirt.virDomainGetAutostart(self, output_ptr) < 0
      output_ptr.read_int == 1
    end

    # Sets the autostart status. This assignment sets the value immediately
    # on the domain.
    #
    # @param [Boolean] value
    # @return [Boolean] The set value
    def autostart=(value)
      FFI::Libvirt.virDomainSetAutostart(self, value ? 1 : 0)
      value
    end

    # Starts the domain (moves it from the inactive to running state), and
    # returns a boolean of whether the call succeeded or not.
    #
    # @return [Boolean]
    def create
      return true if active?
      FFI::Libvirt.virDomainCreate(self) == 0
    end
    alias :start :create

    # Stops a running domain and returns a boolean of whether the call succeeded
    # or not.
    #
    # @return [Boolean]
    def destroy
      FFI::Libvirt.virDomainDestroy(self) == 0
    end
    alias :stop :destroy

    # Suspends an active domain, the process is frozen but the memory is still
    # allocated. Returns a boolean of whether the call succeeded or not.
    #
    # @return [Boolean]
    def suspend
      FFI::Libvirt.virDomainSuspend(self) == 0
    end

    # Resumes a suspended domain, returns a boolean of whether the call
    # succeeded or not.
    #
    # @return [Boolean]
    def resume
      return true if active?
      FFI::Libvirt.virDomainResume(self) == 0
    end

    # Reboots the domain.
    #
    # @return [Boolean]
    def reboot
      FFI::Libvirt.virDomainReboot(self, 0) == 0
    end

    # Shutdown a domain, stopping the domain OS.
    #
    # @return [Boolean]
    def shutdown
      FFI::Libvirt.virDomainShutdown(self) == 0
    end

    # Undefine a domain. This will not stop it if it is running.
    #
    # @return [Boolean]
    def undefine
      FFI::Libvirt.virDomainUndefine(self) == 0
    end

    # Provides the pointer to the domain. This allows this object to be used
    # directly with the FFI layer which expects a `virDomainPtr`.
    #
    # @return [FFI::Pointer]
    def to_ptr
      @pointer
    end

    # Provide a meaningful equality check so that two domains can easily
    # be checked for equality. This works by comparing UUIDs.
    #
    # @return [Boolean]
    def ==(other)
      other.is_a?(Domain) && other.uuid == uuid
    end

    protected

    # Queries the domain info from libvirt to get standard information
    # about this domain.
    def domain_info
      result = FFI::Libvirt::DomainInfo.new
      FFI::Libvirt.virDomainGetInfo(self, result.to_ptr)
      result
    end

    # Cleans the `virDomainPtr` underlying the class when the class is
    # released.
    def finalize(*args)
      FFI::Libvirt.virDomainFree(self)
    end
  end
end
