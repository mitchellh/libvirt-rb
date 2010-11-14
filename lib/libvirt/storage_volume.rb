module Libvirt
  # Represents a single storage volume.
  class StorageVolume
    # Initializes a new {StorageVolume} object given a `virStorageVolPtr`.
    # Do not call this directly. Instead, use the {StoragePool#volumes} collection
    # object to retrieve a specific {StorageVolume}.
    def initialize(pointer)
      @pointer = pointer
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
  end
end
