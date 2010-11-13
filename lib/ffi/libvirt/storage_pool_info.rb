module FFI
  module Libvirt
    # virStoragePoolInfo structure
    class StoragePoolInfo < ::FFI::Struct
      layout :state, :virStoragePoolState,
             :capacity, :ulong_long,
             :allocation, :ulong_long,
             :available, :ulong_long
    end
  end
end
