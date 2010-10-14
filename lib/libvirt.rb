require 'ffi'

module Libvirt
  extend FFI::Library
  ffi_lib "libvirt"

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

  # Pointers for outputting C primitives
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

  # Below attached functions in order of appearance in libvirt.h
  attach_function :virDomainGetSchedulerParameters, [:virDomainPtr, :virSchedParameterPtr, :int_pointer], :int
  attach_function :virDomainSetSchedulerParameters, [:virDomainPtr, :virSchedParameterPtr, :int], :int
  attach_function :virDomainMigrate, [:virDomainPtr, :virConnectPtr, :ulong, :string, :string, :ulong], :virDomainPtr
  attach_function :virDomainMigrateToURI, [:virDomainPtr, :string, :ulong, :string, :ulong], :int
  attach_function :virDomainMigrateSetMaxDowntime, [:virDomainPtr, :ulong_long, :uint], :int

  attach_function :virGetVersion, [:unsigned_long_pointer, :string, :unsigned_long_pointer], :int

  # Connection/disconnection to the Hypervisor
  attach_function :virInitialize, [], :int
  attach_function :virConnectOpen, [:string], :virConnectPtr
  attach_function :virConnectOpenReadOnly, [:string], :virConnectPtr
  attach_function :virConnectOpenAuth, [:string, :virConnectAuthPtr, :int], :virConnectPtr
  attach_function :virConnectRef, [:virConnectPtr], :int
  attach_function :virConnectClose, [:virConnectPtr], :int
  attach_function :virConnectGetType, [:virConnectPtr], :string
  attach_function :virConnectGetVersion, [:virConnectPtr, :unsigned_long_pointer], :int
  attach_function :virConnectGetLibVersion, [:virConnectPtr, :unsigned_long_pointer], :int
  attach_function :virConnectGetHostname, [:virConnectPtr], :string
  attach_function :virConnectGetURI, [:virConnectPtr], :string

  # Capabilities of the connection/driver
  attach_function :virConnectGetMaxVcpus, [:virConnectPtr, :string], :int
  attach_function :virNodeGetInfo, [:virConnectPtr, :virNodeInfoPtr], :int
  attach_function :virConnectGetCapabilities, [:virConnectPtr], :string
  attach_function :virNodeGetFreeMemory, [:virConnectPtr], :ulong_long
  attach_function :virNodeGetSecurityModel, [:virConnectPtr, :virSecurityModelPtr], :int

  # List of running domains
  attach_function :virConnectListDomains, [:virConnectPtr, :int_pointer, :int], :int

  # Number of domains
  attach_function :virConnectNumOfDomains, [:virConnectPtr], :int

  # Get connection from domain
  attach_function :virDomainGetConnect, [:virDomainPtr], :virConnectPtr

  # Domain creation and destruction
  attach_function :virDomainCreateXML, [:virConnectPtr, :string, :uint], :virDomainPtr
  attach_function :virDomainLookupByName, [:virConnectPtr, :string], :virDomainPtr
  attach_function :virDomainLookupByID, [:virConnectPtr, :int], :virDomainPtr
  attach_function :virDomainLookupByUUID, [:virConnectPtr, :string], :virDomainPtr
  attach_function :virDomainLookupByUUIDString, [:virConnectPtr, :string], :virDomainPtr
  attach_function :virDomainShutdown, [:virDomainPtr], :int
  attach_function :virDomainReboot, [:virDomainPtr, :uint], :int
  attach_function :virDomainDestroy, [:virDomainPtr], :int
  attach_function :virDomainRef, [:virDomainPtr], :int
  attach_function :virDomainFree, [:virDomainPtr], :int

  # Domain suspend/resume
  attach_function :virDomainSuspend, [:virDomainPtr, :uint], :int
  attach_function :virDomainResume, [:virDomainPtr, :uint], :int

  # Domain save/restore
  attach_function :virDomainSave, [:virDomainPtr, :string], :int
  attach_function :virDomainRestore, [:virDomainPtr, :string], :int

  # Managed domain save
  attach_function :virDomainManagedSave, [:virDomainPtr, :uint], :int
  attach_function :virDomainHasManagedSaveImage, [:virDomainPtr, :uint], :int
  attach_function :virDomainManagedSaveRemove, [:virDomainPtr, :uint], :int

  # Domain core dump
  attach_function :virDomainCoreDump, [:virDomainPtr, :string, :int], :int

  # Domain runtime information
  attach_function :virDomainGetInfo, [:virDomainPtr, :virDomainInfoPtr], :int

  # Return scheduler type in effect
  attach_function :virDomainGetSchedulerType, [:virDomainPtr, :int_pointer], :string

  # Set memory tunables for the domain
  attach_function :virDomainSetMemoryParameters, [:virDomainPtr, :virMemoryParameterPtr, :int, :uint], :int
  attach_function :virDomainGetMemoryParameters, [:virDomainPtr, :virMemoryParameterPtr, :int_pointer, :uint_pointer], :int

  # Dynamic control of domains
  attach_function :virDomainGetName, [:virDomainPtr], :string
  attach_function :virDomainGetID, [:virDomainPtr], :uint
  attach_function :virDomainGetUUID, [:virDomainPtr, :pointer], :int
  attach_function :virDomainGetUUIDString, [:virDomainPtr, :pointer], :int
  attach_function :virDomainGetOSType, [:virDomainPtr], :string
  attach_function :virDomainGetMaxMemory, [:virDomainPtr], :ulong
  attach_function :virDomainSetMaxMemory, [:virDomainPtr, :ulong], :int
  attach_function :virDomainSetMemory, [:virDomainPtr, :ulong], :int
  attach_function :virDomainGetMaxVcpus, [:virDomainPtr], :int
  attach_function :virDomainGetSecurityLabel, [:virDomainPtr, :virSecurityLabelPtr], :int

  # XML domain description
  attach_function :virDomainGetXMLDesc, [:virDomainPtr, :int], :string
  attach_function :virConnectDomainXMLFromNative, [:virConnectPtr, :string, :string, :uint], :string
  attach_function :virConnectDomainXMLToNative, [:virConnectPtr, :string, :string, :uint], :string
  attach_function :virDomainBlockStats, [:virDomainPtr, :string, :virDomainBlockStatsPtr, :size_t], :int
  attach_function :virDomainInterfaceStats, [:virDomainPtr, :string, :virDomainInterfaceStatsPtr, :size_t], :int
  attach_function :virDomainMemoryStats, [:virDomainPtr, :virDomainMemoryStatsPtr, :uint, :uint], :int
  attach_function :virDomainBlockPeek, [:virDomainPtr, :string, :ulong_long, :size_t, :pointer, :uint], :int
  attach_function :virDomainGetBlockInfo, [:virDomainPtr, :string, :virDomainBlockInfoPtr, :uint], :int
  attach_function :virDomainMemoryPeek, [:virDomainPtr, :ulong_long, :size_t, :pointer, :uint], :int

  # Defined but not running domains
  attach_function :virDomainDefineXML, [:virConnectPtr, :string], :virDomainPtr
  attach_function :virDomainUndefine, [:virDomainPtr], :int
  attach_function :virConnectNumOfDefinedDomains, [:virConnectPtr], :int
  attach_function :virConnectListDefinedDomains, [:virConnectPtr, :pointer, :int], :int
  attach_function :virDomainCreate, [:virDomainPtr], :int
  attach_function :virDomainCreateWithFlags, [:virDomainPtr, :uint], :int
  attach_function :virDomainGetAutostart, [:virDomainPtr, :int_pointer], :int
  attach_function :virDomainSetAutostart, [:virDomainPtr, :int], :int
  attach_function :virDomainSetVcpus, [:virDomainPtr, :uint], :int
  attach_function :virDomainPinVcpu, [:virDomainPtr, :uint, :string, :int], :int # TODO: Arg in is an array
  attach_function :virDomainAttachDevice, [:virDomainPtr, :string], :int
  attach_function :virDomainDetachDevice, [:virDomainPtr, :string], :int
  attach_function :virDomainAttachDeviceFlags, [:virDomainPtr, :string, :uint], :int
  attach_function :virDomainDetachDeviceFlags, [:virDomainPtr, :string, :uint], :int
  attach_function :virDomainUpdateDeviceFlags, [:virDomainPtr, :string, :uint], :int

  # NUMA support
  attach_function :virNodeGetCellsFreeMemory, [:virConnectPtr, :ulong_long_pointer, :int, :int], :int

  # Virtual Networks API
  attach_function :virNetworkGetConnect, [:virNetworkPtr], :virConnectPtr
  attach_function :virConnectNumOfNetworks, [:virConnectPtr], :int
  attach_function :virConnectListNetworks, [:virConnectPtr, :pointer, :int], :int
  attach_function :virConnectNumOfDefinedNetworks, [:virConnectPtr], :int
  attach_function :virConnectListDefinedNetworks, [:virConnectPtr, :pointer, :int], :int
  attach_function :virNetworkLookupByName, [:virConnectPtr, :string], :virNetworkPtr
  attach_function :virNetworkLookupByUUID, [:virConnectPtr, :string], :virNetworkPtr
  attach_function :virNetworkLookupByUUIDString, [:virConnectPtr, :string], :virNetworkPtr
  attach_function :virNetworkCreateXML, [:virConnectPtr, :string], :virNetworkPtr
  attach_function :virNetworkDefineXML, [:virConnectPtr, :string], :virNetworkPtr
  attach_function :virNetworkUndefine, [:virNetworkPtr], :int
  attach_function :virNetworkCreate, [:virNetworkPtr], :int
  attach_function :virNetworkDestroy, [:virNetworkPtr], :int
  attach_function :virNetworkRef, [:virNetworkPtr], :int
  attach_function :virNetworkFree, [:virNetworkPtr], :int
  attach_function :virNetworkGetName, [:virNetworkPtr], :string
  attach_function :virNetworkGetUUID, [:virNetworkPtr, :pointer], :int
  attach_function :virNetworkGetXMLDesc, [:virNetworkPtr, :int], :string
  attach_function :virNetworkGetBridgeName, [:virNetworkPtr], :string
  attach_function :virNetworkGetAutostart, [:virNetworkPtr, :int_pointer], :int
  attach_function :virNetworkSetAutostart, [:virNetworkPtr, :int], :int

  # Physical host interface configuration API
  attach_function :virInterfaceGetConnect, [:virInterfacePtr], :virConnectPtr
  attach_function :virConnectNumOfInterfaces, [:virConnectPtr], :int
  attach_function :virConnectListInterfaces, [:virConnectPtr, :pointer, :int], :int # TODO: String pointer
  attach_function :virConnectNumOfDefinedInterfaces, [:virConnectPtr], :int
  attach_function :virConnectListDefinedInterfaces, [:virConnectPtr, :pointer, :int], :int
  attach_function :virInterfaceLookupByName, [:virConnectPtr, :string], :virInterfacePtr
  attach_function :virInterfaceLookupByMACString, [:virConnectPtr, :string], :virInterfacePtr
  attach_function :virInterfaceGetName, [:virInterfacePtr], :string
  attach_function :virInterfaceGetMACString, [:virInterfacePtr], :string
  attach_function :virInterfaceGetXMLDesc, [:virInterfacePtr, :uint], :string
  attach_function :virInterfaceDefineXML, [:virConnectPtr, :string, :int], :virInterfacePtr
  attach_function :virInterfaceUndefine, [:virInterfacePtr], :int
  attach_function :virInterfaceCreate, [:virInterfacePtr, :int], :int
  attach_function :virInterfaceDestroy, [:virInterfacePtr, :int], :int
  attach_function :virInterfaceRef, [:virInterfacePtr], :int
  attach_function :virInterfaceFree, [:virInterfacePtr], :int

  # Storage pool API
  attach_function :virStoragePoolGetConnect, [:virStoragePoolPtr], :virConnectPtr
  attach_function :virConnectNumOfStoragePools, [:virConnectPtr], :int
  attach_function :virConnectListStoragePools, [:virConnectPtr, :pointer, :int], :int
  attach_function :virConnectNumOfDefinedStoragePools, [:virConnectPtr], :int
  attach_function :virConnectListDefinedStoragePools, [:virConnectPtr, :pointer, :int], :int
  attach_function :virConnectFindStoragePoolSources, [:virConnectPtr, :string, :string, :int], :string
  attach_function :virStoragePoolLookupByName, [:virConnectPtr, :string], :virStoragePoolPtr
  attach_function :virStoragePoolLookupByUUID, [:virConnectPtr, :string], :virStoragePoolPtr
  attach_function :virStoragePoolLookupByUUIDString, [:virConnectPtr, :string], :virStoragePoolPtr
  attach_function :virStoragePoolLookupByVolume, [:virStorageVolPtr], :virStoragePoolPtr
  attach_function :virStoragePoolCreateXML, [:virConnectPtr, :string, :uint], :virStoragePoolPtr
  attach_function :virStoragePoolDefineXML, [:virConnectPtr, :string, :uint], :virStoragePoolPtr
  attach_function :virStoragePoolBuild, [:virStoragePoolPtr, :uint], :int
  attach_function :virStoragePoolUndefine, [:virStoragePoolPtr], :int
  attach_function :virStoragePoolCreate, [:virStoragePoolPtr, :uint], :int
  attach_function :virStoragePoolDestroy, [:virStoragePoolPtr], :int
  attach_function :virStoragePoolDelete, [:virStoragePoolPtr, :uint], :int
  attach_function :virStoragePoolRef, [:virStoragePoolPtr], :int
  attach_function :virStoragePoolFree, [:virStoragePoolPtr], :int
  attach_function :virStoragePoolRefresh, [:virStoragePoolPtr, :uint], :int
  attach_function :virStoragePoolGetName, [:virStoragePoolPtr], :string
  attach_function :virStoragePoolGetUUID, [:virStoragePoolPtr, :string], :int
  attach_function :virStoragePoolGetUUIDString, [:virStoragePoolPtr, :pointer], :int
  attach_function :virStoragePoolGetInfo, [:virStoragePoolPtr, :virStoragePoolInfoPtr], :int
  attach_function :virStoragePoolGetXMLDesc, [:virStoragePoolPtr, :uint], :string
  attach_function :virStoragePoolGetAutostart, [:virStoragePoolPtr, :int_pointer], :int
  attach_function :virStoragePoolSetAutostart, [:virStoragePoolPtr, :int], :int
  attach_function :virStoragePoolNumOfVolumes, [:virStoragePoolPtr], :int
  attach_function :virStoragePoolListVolumes, [:virStoragePoolPtr, :pointer, :int], :int
  attach_function :virStorageVolGetConnect, [:virStorageVolPtr], :virConnectPtr
  attach_function :virStorageVolLookupByName, [:virStoragePoolPtr, :string], :virStorageVolPtr
  attach_function :virStorageVolLookupByKey, [:virConnectPtr, :string], :virStorageVolPtr
  attach_function :virStorageVolLookupByPath, [:virConnectPtr, :string], :virStorageVolPtr
  attach_function :virStorageVolGetName, [:virStorageVolPtr], :string
  attach_function :virStorageVolGetKey, [:virStorageVolPtr], :string
  attach_function :virStorageVolCreateXML, [:virStoragePoolPtr, :string, :uint], :virStorageVolPtr
  attach_function :virStorageVolCreateXMLFrom, [:virStoragePoolPtr, :string, :virStorageVolPtr, :uint], :virStorageVolPtr
  attach_function :virStorageVolDelete, [:virStorageVolPtr, :uint], :int
  attach_function :virStorageVolWipe, [:virStorageVolPtr, :uint], :int
  attach_function :virStorageVolRef, [:virStorageVolPtr], :int
  attach_function :virStorageVolFree, [:virStorageVolPtr], :int
  attach_function :virStorageVolGetInfo, [:virStorageVolPtr, :virStorageVolInfoPtr], :int
  attach_function :virStorageVolGetXMLDesc, [:virStorageVolPtr, :uint], :string
  attach_function :virStorageVolGetPath, [:virStorageVolPtr], :string

  # Deprecated
  attach_function :virDomainCreateLinux, [:virConnectPtr, :string, :uint], :virDomainPtr

  # Host device enumeration
  attach_function :virNodeNumOfDevices, [:virConnectPtr, :string, :uint], :int
  attach_function :virNodeListDevices, [:virConnectPtr, :string, :pointer, :int, :uint], :int
  attach_function :virNodeDeviceLookupByName, [:virConnectPtr, :string], :virNodeDevicePtr
  attach_function :virNodeDeviceGetName, [:virNodeDevicePtr], :string
  attach_function :virNodeDeviceGetParent, [:virNodeDevicePtr], :string
  attach_function :virNodeDeviceNumOfCaps, [:virNodeDevicePtr], :int
  attach_function :virNodeDeviceListCaps, [:virNodeDevicePtr, :pointer, :int], :int
  attach_function :virNodeDeviceGetXMLDesc, [:virNodeDevicePtr, :uint], :string
  attach_function :virNodeDeviceRef, [:virNodeDevicePtr], :int
  attach_function :virNodeDeviceFree, [:virNodeDevicePtr], :int
  attach_function :virNodeDeviceDettach, [:virNodeDevicePtr], :int
  attach_function :virNodeDeviceReAttach, [:virNodeDevicePtr], :int
  attach_function :virNodeDeviceReset, [:virNodeDevicePtr], :int
  attach_function :virNodeDeviceCreateXML, [:virConnectPtr, :string, :uint], :virNodeDevicePtr
  attach_function :virNodeDeviceDestroy, [:virNodeDevicePtr], :int

  # Domain event notification
  attach_function :virConnectDomainEventRegister, [:virConnectPtr, :virConnectDomainEventCallback, :void_pointer, :virFreeCallback], :int
  attach_function :virConnectDomainEventDeregister, [:virConnectPtr, :virConnectDomainEventCallback], :int

  # Events
  attach_function :virEventRegisterImpl, [:virEventAddHandleFunc, :virEventUpdateHandleFunc, :virEventRemoveHandleFunc, :virEventAddTimeoutFunc, :virEventUpdateTimeoutFunc, :virEventRemoveTimeoutFunc], :void

  # Secret manipulation API
  attach_function :virSecretGetConnect, [:virSecretPtr], :virConnectPtr
  attach_function :virConnectNumOfSecrets, [:virConnectPtr], :int
  attach_function :virConnectListSecrets, [:virConnectPtr, :pointer, :int], :int
  attach_function :virSecretLookupByUUID, [:virConnectPtr, :string], :virSecretPtr
  attach_function :virSecretLookupByUUIDString, [:virConnectPtr, :string], :virSecretPtr
  attach_function :virSecretLookupByUsage, [:virConnectPtr, :int, :string], :virSecretPtr
  attach_function :virSecretDefineXML, [:virConnectPtr, :string, :uint], :virSecretPtr
  attach_function :virSecretGetUUID, [:virSecretPtr, :pointer], :int
  attach_function :virSecretGetUUIDString, [:virSecretPtr, :pointer], :int
  attach_function :virSecretGetUsageType, [:virSecretPtr], :int
  attach_function :virSecretGetUsageID, [:virSecretPtr], :string
  attach_function :virSecretGetXMLDesc, [:virSecretPtr, :uint], :string
  attach_function :virSecretSetValue, [:virSecretPtr, :string, :size_t, :uint], :int
  attach_function :virSecretGetValue, [:virSecretPtr, :size_t, :uint], :string
  attach_function :virSecretUndefine, [:virSecretPtr], :int
  attach_function :virSecretRef, [:virSecretPtr], :int
  attach_function :virSecretFree, [:virSecretPtr], :int

  # Stream API
  attach_function :virStreamNew, [:virConnectPtr, :uint], :virStreamPtr
  attach_function :virStreamRef, [:virStreamPtr], :int
  attach_function :virStreamSend, [:virStreamPtr, :string, :size_t], :int
  attach_function :virStreamRecv, [:virStreamPtr, :pointer, :size_t], :int
  attach_function :virStreamSendAll, [:virStreamPtr, :virStreamSourceFunc, :void_pointer], :int
  attach_function :virStreamRecvAll, [:virStreamPtr, :virStreamSinkFunc, :void_pointer], :int
  attach_function :virStreamEventAddCallback, [:virStreamPtr, :int, :virStreamEventCallback, :void_pointer, :virFreeCallback], :int
  attach_function :virStreamEventUpdateCallback, [:virStreamPtr, :int], :int
  attach_function :virStreamEventRemoveCallback, [:virStreamPtr], :int
  attach_function :virStreamFinish, [:virStreamPtr], :int
  attach_function :virStreamAbort, [:virStreamPtr], :int
  attach_function :virStreamFree, [:virStreamPtr], :int

  attach_function :virDomainIsActive, [:virDomainPtr], :int
  attach_function :virDomainIsPersistent, [:virDomainPtr], :int
  attach_function :virNetworkIsActive, [:virNetworkPtr], :int
  attach_function :virNetworkIsPersistent, [:virNetworkPtr], :int
  attach_function :virStoragePoolIsActive, [:virStoragePoolPtr], :int
  attach_function :virStoragePoolIsPersistent, [:virStoragePoolPtr], :int
  attach_function :virInterfaceIsActive, [:virInterfacePtr], :int
  attach_function :virConnectIsEncrypted, [:virConnectPtr], :int
  attach_function :virConnectIsSecure, [:virConnectPtr], :int

  # CPU Specification API
  attach_function :virConnectCompareCPU, [:virConnectPtr, :string, :uint], :int
  attach_function :virConnectBaselineCPU, [:virConnectPtr, :pointer, :uint, :uint], :string

  # Domain jobs
  attach_function :virDomainGetJobInfo, [:virDomainPtr, :virDomainJobInfoPtr], :int
  attach_function :virDomainAbortJob, [:virDomainPtr], :int

  # Domain snapshots
  attach_function :virDomainSnapshotCreateXML, [:virDomainPtr, :string, :uint], :virDomainSnapshotPtr
  attach_function :virDomainSnapshotGetXMLDesc, [:virDomainSnapshotPtr, :uint], :string
  attach_function :virDomainSnapshotNum, [:virDomainPtr, :uint], :int
  attach_function :virDomainSnapshotListNames, [:virDomainPtr, :pointer, :int, :uint], :int
  attach_function :virDomainSnapshotLookupByName, [:virDomainPtr, :string, :uint], :virDomainSnapshotPtr
  attach_function :virDomainHasCurrentSnapshot, [:virDomainPtr, :uint], :int
  attach_function :virDomainSnapshotCurrent, [:virDomainPtr, :uint], :virDomainSnapshotPtr
  attach_function :virDomainRevertToSnapshot, [:virDomainSnapshotPtr, :uint], :int
  attach_function :virDomainSnapshotDelete, [:virDomainSnapshotPtr, :uint], :int
  attach_function :virDomainSnapshotFree, [:virDomainSnapshotPtr], :int

  attach_function :virConnectDomainEventRegisterAny, [:virConnectPtr, :virDomainPtr, :int, :virConnectDomainEventGenericCallback, :void_pointer, :virFreeCallback], :int
  attach_function :virConnectDomainEventDeregisterAny, [:virConnectPtr, :int], :int

  # Network filters API
  attach_function :virConnectNumOfNWFilters, [:virConnectPtr], :int
  attach_function :virConnectListNWFilters, [:virConnectPtr, :pointer, :int], :int
  attach_function :virNWFilterLookupByName, [:virConnectPtr, :string], :virNWFilterPtr
  attach_function :virNWFilterLookupByUUID, [:virConnectPtr, :string], :virNWFilterPtr
  attach_function :virNWFilterLookupByUUIDString, [:virConnectPtr, :string], :virNWFilterPtr
  attach_function :virNWFilterDefineXML, [:virConnectPtr, :string], :virNWFilterPtr
  attach_function :virNWFilterUndefine, [:virNWFilterPtr], :int
  attach_function :virNWFilterRef, [:virNWFilterPtr], :int
  attach_function :virNWFilterFree, [:virNWFilterPtr], :int
  attach_function :virNWFilterGetName, [:virNWFilterPtr], :string
  attach_function :virNWFilterGetUUID, [:virNWFilterPtr, :pointer], :int
  attach_function :virNWFilterGetUUIDString, [:virNWFilterPtr, :pointer], :int
  attach_function :virNWFilterGetXMLDesc, [:virNWFilterPtr, :int], :string
end
