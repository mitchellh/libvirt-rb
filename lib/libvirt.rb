require 'ffi/libvirt'

module Libvirt
  autoload :Connection, 'libvirt/connection'
  autoload :Domain, 'libvirt/domain'
  autoload :Error, 'libvirt/error'
  autoload :Exception, 'libvirt/exception'

  # Initializes the library by calling `virInitialize`. Most methods
  # in libvirt actually call this themselves, so its not strictly
  # necessary. However, it is good practice and is **highly** recommended
  # in a multithreaded environment. This will raise an {Error::InitializeError}
  # upon failure.
  def self.initialize!
    raise Error::InitializeError if FFI::Libvirt.virInitialize < 0
    true
  end
end
