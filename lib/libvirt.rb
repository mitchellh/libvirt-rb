require 'nokogiri'
require 'ffi/libvirt'

# This module is the namespace for the higher level library on top of
# libvirt, in typicaly Ruby library style. In contrast with {FFI::Libvirt}
# which is a direct layer on top of FFI, this namespace abstracts much of
# the manual work away (especially pointer handling) and exposes aspects
# of the API through nice Ruby objects.
#
# Due to the nature of this side of the project, there may be certain features
# not readily available which are supported by the API. If this is the case,
# you can use the {FFI::Libvirt} library alongside this side.
module Libvirt
  autoload :Collection, 'libvirt/collection'
  autoload :Connection, 'libvirt/connection'
  autoload :Domain, 'libvirt/domain'
  autoload :Error, 'libvirt/error'
  autoload :Exception, 'libvirt/exception'
  autoload :Network, 'libvirt/network'
  autoload :Spec, 'libvirt/spec'
  autoload :StoragePool, 'libvirt/storage_pool'
  autoload :StorageVolume, 'libvirt/storage_volume'

  # Initializes the library by calling `virInitialize`. Most methods
  # in libvirt actually call this themselves, so its not strictly
  # necessary. However, it is good practice and is **highly** recommended
  # that this is called at a same place in a multi-threaded environment.
  def self.initialize!
    FFI::Libvirt.virInitialize == 0
  end

  # Returns the version of `libvirt` on the client machine. **This is
  # not the version of the `libvirt` ruby library.** The result is
  # return as an array of `[major, minor, patch]`.
  #
  # @return [Array]
  def self.version
    FFI::Libvirt.version
  end

  # Connect to a hypervisor using libvirt. This is a shortcut to
  # instantiating a {Connection} object, therefore for documentation on
  # the arguments and return value for this method, please consult
  # {Connection#initialize}.
  def self.connect(*args)
    Connection.new(*args)
  end
end

# Disable the stderr output which libvirt defaults to.
Libvirt::Error.on_error
