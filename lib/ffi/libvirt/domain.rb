module FFI
  module Libvirt
    class DomainInfo < ::FFI::Struct
      layout :state, :uchar,
             :maxMem, :ulong,
             :memory, :ulong,
             :nrVirtCpu, :ushort,
             :cpuTime, :ulong_long
    end
  end
end
