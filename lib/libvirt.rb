require 'ffi/libvirt'

# Disable the stderr output which libvirt defaults to.
FFI::Libvirt.virSetErrorFunc(nil) {}

module Libvirt
  autoload :Connection, 'libvirt/connection'
  autoload :Domain, 'libvirt/domain'
  autoload :Error, 'libvirt/error'
  autoload :Exception, 'libvirt/exception'

  # Initializes the library by calling `virInitialize`. Most methods
  # in libvirt actually call this themselves, so its not strictly
  # necessary. However, it is good practice and is **highly** recommended
  # in a multithreaded environment. This will raise an {Exception::InitializeError}
  # upon failure.
  def self.initialize!
    raise Error::InitializeError if FFI::Libvirt.virInitialize < 0
    true
  end

  # Returns the version of `libvirt` on the client machine. **This is
  # not the version of the `libvirt` ruby library.** The result is
  # return as an array of `[major, minor, patch]`.
  #
  # @return [Array]
  def self.version
    FFI::Libvirt.version
  end
end
