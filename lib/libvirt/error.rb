module Libvirt
  # Contains all the potential exceptions which the library can
  # throw.
  module Error
    class Error < StandardError; end
    class ConnectionFailed < Error; end
    class InitializationError < Error; end
  end
end
