module FFI
  module Libvirt
    # Functions from virterror.h in the order they appear
    attach_function :virGetLastError, [], :virErrorPtr
    attach_function :virSaveLastError, [], :virErrorPtr
    attach_function :virResetLastError, [], :void
    attach_function :virResetError, [:virErrorPtr], :void
    attach_function :virFreeError, [:virErrorPtr], :void
    attach_function :virConnGetLastError, [:virConnectPtr], :virErrorPtr
    attach_function :virConnResetLastError, [:virConnectPtr], :void
    attach_function :virCopyLastError, [:virErrorPtr], :int
    attach_function :virDefaultErrorFunc, [:virErrorPtr], :void
    attach_function :virSetErrorFunc, [:void_pointer, :virErrorFunc], :void
    attach_function :virConnSetErrorFunc, [:virConnectPtr, :void_pointer, :virErrorFunc], :void
    attach_function :virConnCopyLastError, [:virConnectPtr, :virErrorPtr], :int
  end
end
