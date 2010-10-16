module FFI
  module Libvirt
    class Error < ::FFI::Struct
      # Note: The "DEPRECATED" notes below are important and if you use
      # these you should take extreme caution since the error struct doesn't
      # properly increaes the reference count on this objects, so its likely
      # they are no longer valid. They exist for backwards compatibility.

      layout :code, :virErrorNumber,
             :domain, :virErrorDomain,
             :message, :string,
             :level, :virErrorLevel,
             :conn, :virConnectPtr, # DEPRECATED
             :dom, :virDomainPtr, # DEPRECATED
             :str1, :string,
             :str2, :string,
             :str3, :string,
             :int1, :int,
             :int2, :int,
             :net, :virNetworkPtr # DEPRECATED
    end
  end
end
