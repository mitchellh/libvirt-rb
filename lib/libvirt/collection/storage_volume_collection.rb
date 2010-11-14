module Libvirt
  module Collection
    # Represents a collection of storage volumes, which belongs to a
    # storage pool.
    class StorageVolumeCollection < AbstractCollection
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
