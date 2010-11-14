module Libvirt
  module Collection
    # Represents a collection of storage pools.
    class StoragePoolCollection < AbstractCollection
      # Search for a storage pool. This will first search by name and
      # then by UUID, returning the first result returned.
      #
      # @return [StoragePool]
      def find(value)
        result = find_by_name(value) rescue nil
        result ||= find_by_uuid(value) rescue nil
      end

      # Search for a storage pool by name.
      #
      # @return [StoragePool]
      def find_by_name(name)
        nil_or_object(FFI::Libvirt.virStoragePoolLookupByName(interface, name), StoragePool)
      end

      # Search for a storage pool by UUID.
      #
      # @return [StoragePool]
      def find_by_uuid(uuid)
        nil_or_object(FFI::Libvirt.virStoragePoolLookupByUUIDString(interface, uuid), StoragePool)
      end

      # Returns the inactive storage pools.
      #
      # @return [Array<StoragePool>]
      def inactive
        read_array(:virConnectListDefinedStoragePools, :virConnectNumOfDefinedStoragePools, :string).collect do |name|
          find_by_name(name)
        end
      end

      # Returns the active storage pools.
      #
      # @return [Array<StoragePool>]
      def active
        read_array(:virConnectListStoragePools, :virConnectNumOfStoragePools, :string).collect do |name|
          find_by_name(name)
        end
      end

      # Returns all storage pools.
      #
      # @return [Array<StoragePool>]
      def all
        inactive + active
      rescue Exception::LibvirtError
        # If inactive isn't supported, then we just return the active
        # storage pools.
        active
      end
    end
  end
end
