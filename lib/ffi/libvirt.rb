require 'ffi'

module FFI
  # The FFI Libvirt module contains the raw access to the Libvirt C
  # API. This module contains no fluff or nice abstractions above the API,
  # and is actually a way to access the C API directly. This also means
  # that it is up to you to manage all the pointers and so on that come
  # with this power.
  module Libvirt
    extend FFI::Library
    ffi_lib "libvirt"

    autoload :Util, 'ffi/libvirt/util'
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
require 'ffi/libvirt/domain_info'
require 'ffi/libvirt/error'
require 'ffi/libvirt/node_info'
require 'ffi/libvirt/storage_pool_info'
