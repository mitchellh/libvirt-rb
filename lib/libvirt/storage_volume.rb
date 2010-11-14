module Libvirt
  # Represents a single storage volume.
  class StorageVolume
    # Initializes a new {StorageVolume} object given a `virStorageVolPtr`.
    # Do not call this directly. Instead, use the {StoragePool#volumes} collection
    # object to retrieve a specific {StorageVolume}.
    def initialize(pointer)
      @pointer = pointer
      ObjectSpace.define_finalizer(self, method(:finalize))
    end

    # Returns a key for this storage volume. The key is a unique identifier.
    #
    # @return [String]
    def key
      FFI::Libvirt.virStorageVolGetKey(self)
    end
    alias :uuid :key

    # Returns the name of this storage volume.
    #
    # @return [String]
    def name
      FFI::Libvirt.virStorageVolGetName(self)
    end

    # Returns the path of this storage volume.
    #
    # @return [String]
    def path
      FFI::Libvirt.virStorageVolGetPath(self)
    end

    # Returns the type of this storage volume.
    #
    # @return [Symbol]
    def type
      info[:type]
    end

    # Returns the capacity of this volume in bytes.
    #
    # @return [Integer]
    def capacity
      info[:capacity]
    end

    # Returns the currently allocated number of bytes.
    #
    # @return [Integer]
    def allocation
      info[:allocation]
    end

    # Wipe the contents of a volume so it is not readable in the future.
    #
    # @return [Boolean]
    def wipe
      FFI::Libvirt.virStorageVolWipe(self, 0) == 0
    end

    # Delete the storage volume rom the pool.
    #
    # @return [Boolean]
    def delete
      FFI::Libvirt.virStorageVolDelete(self, 0) == 0
    end

    # Returns the XML description of this storage volume.
    #
    # @return [String]
    def xml
      FFI::Libvirt.virStorageVolGetXMLDesc(self, 0)
    end

    # Returns the actual `virStorageVolPtr` underlying this structure.
    #
    # @return [FFI::Pointer]
    def to_ptr
      @pointer
    end

    # Provide a meaningful equality check so that two storage volumes
    # can eaisly be checked for equality.
    #
    # @return [Boolean]
    def ==(other)
      other.is_a?(StorageVolume) && other.uuid == uuid
    end

    protected

    # Returns the {FFI::Libvirt::StorageVolumeInfo} object for this volume.
    # The various fields of the info struct are accessible via other getters.
    #
    # @return [FFI::Libvirt::StorageVolumeInfo]
    def info
      result = FFI::Libvirt::StorageVolumeInfo.new
      FFI::Libvirt.virStorageVolGetInfo(self, result.to_ptr)
      result
    end

    # Release the resources underlying this storage volume. This is called
    # automatically when this volume is garbage collected.
    def finalize(*args)
      FFI::Libvirt.virStorageVolFree(self)
    end
  end
end
