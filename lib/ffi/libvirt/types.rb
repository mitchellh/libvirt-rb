module FFI
  module Libvirt
    # Typedefs for various pointers to libvirt structures
    typedef :pointer, :virConnectPtr
    typedef :pointer, :virConnectAuthPtr
    typedef :pointer, :virDomainPtr
    typedef :pointer, :virDomainBlockInfoPtr
    typedef :pointer, :virDomainBlockStatsPtr
    typedef :pointer, :virDomainInfoPtr
    typedef :pointer, :virDomainInterfaceStatsPtr
    typedef :pointer, :virDomainJobInfoPtr
    typedef :pointer, :virDomainMemoryStatsPtr
    typedef :pointer, :virDomainSnapshotPtr
    typedef :pointer, :virInterfacePtr
    typedef :pointer, :virMemoryParameterPtr
    typedef :pointer, :virNetworkPtr
    typedef :pointer, :virNodeDevicePtr
    typedef :pointer, :virNodeInfoPtr
    typedef :pointer, :virNWFilterPtr
    typedef :pointer, :virSchedParameterPtr
    typedef :pointer, :virSecretPtr
    typedef :pointer, :virSecurityModelPtr
    typedef :pointer, :virSecurityLabelPtr
    typedef :pointer, :virStoragePoolPtr
    typedef :pointer, :virStoragePoolInfoPtr
    typedef :pointer, :virStorageVolPtr
    typedef :pointer, :virStorageVolInfoPtr
    typedef :pointer, :virStreamPtr
    typedef :pointer, :virVcpuInfoPtr

    # Pointers for C primitives
    typedef :pointer, :uchar_pointer
    typedef :pointer, :int_pointer
    typedef :pointer, :uint_pointer
    typedef :pointer, :unsigned_long_pointer
    typedef :pointer, :ulong_long_pointer
    typedef :pointer, :void_pointer

    # Callbacks
    callback :virConnectDomainEventCallback, [:virConnectPtr, :virDomainPtr, :int, :int, :void_pointer], :int
    callback :virFreeCallback, [:void_pointer], :void
    callback :virEventHandleCallback, [:int, :int, :int, :void_pointer], :void
    callback :virEventAddHandleFunc, [:int, :int, :virEventHandleCallback, :void_pointer, :virFreeCallback], :int
    callback :virEventUpdateHandleFunc, [:int, :int], :void
    callback :virEventRemoveHandleFunc, [:int], :int
    callback :virEventTimeoutCallback, [:int, :void_pointer], :void
    callback :virEventAddTimeoutFunc, [:int, :virEventTimeoutCallback, :void_pointer, :virFreeCallback], :int
    callback :virEventUpdateTimeoutFunc, [:int, :int], :void
    callback :virEventRemoveTimeoutFunc, [:int], :int
    callback :virStreamSourceFunc, [:virStreamPtr, :string, :size_t, :void_pointer], :int
    callback :virStreamSinkFunc, [:virStreamPtr, :string, :size_t, :void_pointer], :int
    callback :virStreamEventCallback, [:virStreamPtr, :int, :void_pointer], :void
    callback :virConnectDomainEventGenericCallback, [:virConnectPtr, :virDomainPtr, :void_pointer], :void

    # Enums
    enum :virDomainState, [:nostate, :running, :blocked, :paused, :shutdown, :shutoff, :crashed]
    enum :virStoragePoolState, [:inactive, :building, :running, :degraded, :inaccessible]
  end
end
