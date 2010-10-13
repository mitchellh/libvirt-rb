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
  typedef :pointer, :virDomainMemoryStatsPtr
  typedef :pointer, :virMemoryParameterPtr
  typedef :pointer, :virNetworkPtr
  typedef :pointer, :virNodeInfoPtr
  typedef :pointer, :virSecurityModelPtr
  typedef :pointer, :virSecurityLabelPtr

  # Pointers for outputting C primitives
  typedef :pointer, :int_pointer
  typedef :pointer, :uint_pointer
  typedef :pointer, :unsigned_long_pointer
  typedef :pointer, :ulong_long_pointer

  # Below attached functions in order of appearance in libvirt.h
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
end
