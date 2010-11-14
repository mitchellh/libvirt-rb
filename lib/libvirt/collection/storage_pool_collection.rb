module Libvirt
  module Collection
    # Represents a collection of storage pools.
    class StoragePoolCollection < AbstractCollection
      # Returns the inactive storage pools.
      #
      # @return [Array<StoragePool>]
      def inactive
        read_array(:virConnectListDefinedStoragePools, :virConnectNumOfDefinedStoragePools, :string).collect do |name|
          pointer = FFI::Libvirt.virStoragePoolLookupByName(interface, name)
          pointer.null? ? nil : StoragePool.new(pointer)
        end
      end

      # Returns the active storage pools.
      #
      # @return [Array<StoragePool>]
      def active
        read_array(:virConnectListStoragePools, :virConnectNumOfStoragePools, :string).collect do |name|
          pointer = FFI::Libvirt.virStoragePoolLookupByName(interface, name)
          pointer.null? ? nil : StoragePool.new(pointer)
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
