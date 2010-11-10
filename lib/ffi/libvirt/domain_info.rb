module FFI
  module Libvirt
    # virDomainInfo structure, used to represent a single domain.
    class DomainInfo < ::FFI::Struct
      layout :state, :virDomainState,
             :maxMem, :ulong,
             :memory, :ulong,
             :nrVirtCpu, :ushort,
             :cpuTime, :ulong_long
    end
  end
end
