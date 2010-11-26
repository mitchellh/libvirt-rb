module Libvirt
  # Contains all the potential exceptions which the library can
  # throw. This is different from a {Libvirt::Error}, which represents
  # an actual `libvirt` error object.
  module Exception
    # Represents an exceptional event within the Libvirt library.
    # This contains an `error` readable attribute which, if available,
    # is a {Libvirt::Error} object, which contains more details
    # about the error which occurred.
    class LibvirtError < StandardError
      attr_reader :error

      def initialize(error)
        @error = error
        super(error.message)
      end
    end

    # Represents an exception in parsing an XML spec into a Ruby
    # {Libvirt::Spec} object.
    class UnparseableSpec < StandardError
      def initialize(tags)
        tags = tags.map { |tag| tag.name }
        super("Unsupported tags found. This is either a bug or the XML string given is invalid. Tags: #{tags}")
      end
    end
  end
end
