module Libvirt
  module Collection
    autoload :AbstractCollection, 'libvirt/collection/abstract_collection'
    autoload :DomainCollection, 'libvirt/collection/domain_collection'
    autoload :InterfaceCollection, 'libvirt/collection/interface_collection'
  end
end
