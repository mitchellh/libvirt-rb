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
        nil_or_object(FFI::Libvirt.virStorageVolLookupByName(interface, name), StorageVolume)
      end

      # Searches for a storage volume by key.
      #
      # @return [StorageVolume]
      def find_by_key(key)
        nil_or_object(FFI::Libvirt.virStorageVolLookupByKey(interface.connection, key), StorageVolume)
      end

      # Searches for a storage volume by path.
      #
      # @return [StorageVolume]
      def find_by_path(path)
        nil_or_object(FFI::Libvirt.virStorageVolLookupByPath(interface.connection, path), StorageVolume)
      end

      # Creates a new storage volume from an XML specification.
      #
      # @return [StorageVolume]
      def create(spec)
        nil_or_object(FFI::Libvirt.virStorageVolCreateXML(interface, spec, 0), StorageVolume)
      end

      # Returns all storage volumes. Its unnecessary to call this directly
      # since the {#all} array is delegated for the various `Array`-like
      # methods.
      #
      # @return [Array]
      def all
        read_array(:virStoragePoolListVolumes, :virStoragePoolNumOfVolumes, :string).collect do |name|
          find_by_name(name)
        end
      end
    end
  end
end
