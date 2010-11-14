module Libvirt
  module Collection
    autoload :AbstractCollection, 'libvirt/collection/abstract_collection'
    autoload :DomainCollection, 'libvirt/collection/domain_collection'
    autoload :InterfaceCollection, 'libvirt/collection/interface_collection'
    autoload :NetworkCollection, 'libvirt/collection/network_collection'
    autoload :NodeDeviceCollection, 'libvirt/collection/node_device_collection'
    autoload :NWFilterCollection, 'libvirt/collection/nwfilter_collection'
    autoload :StoragePoolCollection, 'libvirt/collection/storage_pool_collection'
    autoload :StorageVolumeCollection, 'libvirt/collection/storage_volume_collection'
  end
end
