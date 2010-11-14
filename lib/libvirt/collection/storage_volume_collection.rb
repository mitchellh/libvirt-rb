module Libvirt
  module Collection
    # Represents a collection of storage volumes, which belongs to a
    # storage pool.
    class StorageVolumeCollection < AbstractCollection
      # Searches for a storage volume. This will search by name, then by
      # key, then finally by path. If no storage volume is found, nil will
      # be returned.
      #
      # @return [StorageVolume]
      def find(value)
        result = find_by_name(value) rescue nil
        result ||= find_by_key(value) rescue nil
        result ||= find_by_path(value) rescue nil
      end

      # Searches for a storage volume by name.
      #
      # @return [StorageVolume]
      def find_by_name(name)
        ptr = FFI::Libvirt.virStorageVolLookupByName(interface, name)
        ptr.null? ? nil : StorageVolume.new(ptr)
      end

      # Searches for a storage volume by key.
      #
      # @return [StorageVolume]
      def find_by_key(key)
        ptr = FFI::Libvirt.virStorageVolLookupByKey(interface.connection, key)
        ptr.null? ? nil : StorageVolume.new(ptr)
      end

      # Searches for a storage volume by path.
      #
      # @return [StorageVolume]
      def find_by_path(path)
        ptr = FFI::Libvirt.virStorageVolLookupByPath(interface.connection, path)
        ptr.null? ? nil : StorageVolume.new(ptr)
      end

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
