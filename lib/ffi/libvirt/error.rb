module FFI
  module Libvirt
    class Error < ::FFI::Struct
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
             :net, :virNetworkPtr
    end
  end
end
