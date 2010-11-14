module Libvirt
  module Collection
    # Represents a collection of devices on a given node. Retrieve
    # this collection using {Node#devices}.
    class NodeDeviceCollection < AbstractCollection
      def all
        # We can't use the `read_array` helper here due to the methods being
        # a bit different.
        count_max = FFI::Libvirt.virNodeNumOfDevices(interface, nil, 0)
        output_ptr = FFI::MemoryPointer.new(:pointer, count_max)
        count_returned = FFI::Libvirt.virNodeListDevices(interface, nil, output_ptr, count_max, 0)
        output_ptr.get_array_of_string(0, count_returned).collect do |name|
          ptr = FFI::Libvirt.virNodeDeviceLookupByName(interface, name)
          ptr.null? ? nil : NodeDevice.new(ptr)
        end
      end
    end
  end
end
