require 'ffi'

module FFI
  module Libvirt
    extend FFI::Library
    ffi_lib "libvirt"
  end
end

# The order matters here, sadly. If you muck with the ordering and
# no exceptions are raised while running tests, you're probably okay.
# But, still, be careful.
require 'ffi/libvirt/types'
require 'ffi/libvirt/version'
require 'ffi/libvirt/functions'
require 'ffi/libvirt/error_types'
require 'ffi/libvirt/error_functions'
require 'ffi/libvirt/domain'
require 'ffi/libvirt/error'

