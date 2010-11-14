module FFI
  module Libvirt
    # struct _virStorageVolInfo {
    #  int type;                      /* virStorageVolType flags */
    #  unsigned long long capacity;   /* Logical size bytes */
    #  unsigned long long allocation; /* Current allocation bytes */
    #};
    class StorageVolumeInfo < ::FFI::Struct
      layout :type, :virStorageVolType,
             :capacity, :ulong_long,
             :allocation, :ulong_long
    end
  end
end
