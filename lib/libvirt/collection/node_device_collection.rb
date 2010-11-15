module Libvirt
  module Collection
    # Represents a collection of devices on a given node. Retrieve
    # this collection using {Node#devices}.
    class NodeDeviceCollection < AbstractCollection
      # Create a node device on the host system.
      #
      # @return [NodeDevice]
      def create(spec)
        nil_or_object(FFI::Libvirt.virNodeDeviceCreateXML(interface, spec, 0), NodeDevice)
      end

      # Returns all of the node devices for the given connection.
      #
      # @return [Array<NodeDevice>]
      def all
        # We can't use the `read_array` helper here due to the methods being
        # a bit different.
        count_max = FFI::Libvirt.virNodeNumOfDevices(interface, nil, 0)
        output_ptr = FFI::MemoryPointer.new(:pointer, count_max)
        count_returned = FFI::Libvirt.virNodeListDevices(interface, nil, output_ptr, count_max, 0)

        output_ptr.get_array_of_string(0, count_returned).collect do |name|
          nil_or_object(FFI::Libvirt.virNodeDeviceLookupByName(interface, name), NodeDevice)
        end
      end
    end
  end
end
