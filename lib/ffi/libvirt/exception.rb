module FFI
  module Libvirt
    # Error raised when the libvirt C library is missing.
    class MissingLibError < StandardError
      def initialize
        super("The libvirt C library could not be loaded. Is it properly installed?")
      end
    end
  end
end
