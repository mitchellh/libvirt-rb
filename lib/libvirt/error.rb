module Libvirt
  # Represents the actual `libvirt` error object which most erroneous
  # events set. This contains important information such as the message,
  # domain, etc.
  class Error
    @@error_block = nil

    attr_reader :interface

    class << self
      # Gets the last error (if there is one) and returns the {Error}
      # representing it.
      #
      # @return [Error]
      def last_error
        pointer = FFI::Libvirt.virGetLastError
        return nil if pointer.null?
        new(pointer)
      end

      # Sets an error handling function. This will call the given block
      # whenever an error occurs within libvirt.
      def on_error(&block)
        @@error_block = block
      end

      protected

      def error_handler(userdata, error_ptr)
        @@error_block.call(new(error_ptr)) if @@error_block
      end
    end

    # This proc needs to be assigned to a constant so that it is never GC'd
    # and can be assigned as a callback to the API.
    ERROR_HANDLER_PROC = Error.method(:error_handler)
    FFI::Libvirt.virSetErrorFunc(nil, ERROR_HANDLER_PROC)

    # Initializes a new error object. This shouldn't be called publicly.
    # Instead use {last_error} or obtain the error from any of the exceptions
    # which the library raises.
    def initialize(pointer)
      @interface = FFI::Libvirt::Error.new(pointer)
    end

    # Returns the error code of the error. Internally, this is represented
    # by a C `enum`, so this will actually return a Ruby `Symbol` representation
    # of the error.
    #
    # @return [Symbol]
    def code
      interface[:code]
    end

    # Returns the domain or "category" in which this error occured. This
    # is represented internally as a C `enum`, so this will actually return
    # a Ruby `symbol`.
    #
    # @return [Symbol]
    def domain
      interface[:domain]
    end

    # Returns a human-friendly message related to the error.
    #
    # @return [String]
    def message
      interface[:message]
    end
  end
end
