module Libvirt
  module Collection
    # Represents a collection of storage volumes, which belongs to a
    # storage pool.
    class StorageVolumeCollection < AbstractCollection
      # Creates a new storage volume from an XML specification.
      #
      # @return [StorageVolume]
      def create(spec)
        result = FFI::Libvirt.virStorageVolCreateXML(interface, spec, 0)
        result ? StorageVolume.new(result) : nil
      end

      # Returns all storage volumes. Its unnecessary to call this directly
      # since the {#all} array is delegated for the various `Array`-like
      # methods.
      #
      # @return [Array]
      def all
        read_array(:virStoragePoolListVolumes, :virStoragePoolNumOfVolumes, :string).collect do |name|
          ptr = FFI::Libvirt.virStorageVolLookupByName(interface, name)
          ptr.null? ? nil : StorageVolume.new(ptr)
        end
      end
    end
  end
end
