module Libvirt
  # This is the namespace which contains all the classes which define
  # specifications for domains, networks, storage pools, etc. These
  # specifications are used to define and launch them via libvirt.
  # The specifications are converted down to XML for consumption by
  # libvirt. Please view the example files for examples on how to use
  # the specs.
  module Spec
    autoload :Device, 'libvirt/spec/device'
    autoload :Domain, 'libvirt/spec/domain'
    autoload :Network, 'libvirt/spec/network'
    autoload :Util, 'libvirt/spec/util'
  end
end
