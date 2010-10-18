module FFI
  module Libvirt
    libvirt_version "0.6.0" do
      attach_function :virGetLastError, [], :virErrorPtr
      attach_function :virResetLastError, [], :void
      attach_function :virResetError, [:virErrorPtr], :void
      attach_function :virConnGetLastError, [:virConnectPtr], :virErrorPtr
      attach_function :virConnResetLastError, [:virConnectPtr], :void
      attach_function :virCopyLastError, [:virErrorPtr], :int
      attach_function :virDefaultErrorFunc, [:virErrorPtr], :void
      attach_function :virSetErrorFunc, [:void_pointer, :virErrorFunc], :void
      attach_function :virConnSetErrorFunc, [:virConnectPtr, :void_pointer, :virErrorFunc], :void
      attach_function :virConnCopyLastError, [:virConnectPtr, :virErrorPtr], :int
    end

    libvirt_version "0.6.1" do
      attach_function :virSaveLastError, [], :virErrorPtr
      attach_function :virFreeError, [:virErrorPtr], :void
    end
  end
end
