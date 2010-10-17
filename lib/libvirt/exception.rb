module Libvirt
  # Contains all the potential exceptions which the library can
  # throw. This is different from a {Libvirt::Error}, which represents
  # an actual `libvirt` error object.
  module Exception
    # Represents an exceptional event within the Libvirt library.
    # This contains an `error` readable attribute which, if available,
    # is a {Libvirt::Error} object, which contains more details
    # about the error which occurred.
    class Error < StandardError
      attr_reader :error

      def initialize(error=nil)
        # This works because error.message will be nil if there
        # wasn't an error.
        @error = error || Libvirt::Error.last_error
        super(@error.message)
      end
    end

    class ConnectionFailed < Error; end
    class InitializationError < Error; end
  end
end
