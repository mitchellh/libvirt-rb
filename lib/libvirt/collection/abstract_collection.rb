require 'forwardable'

module Libvirt
  module Collection
    # Abstract parent class for all collections within libvirt.
    #
    # Subclasses of any collection are expected to implement the function
    # `all` which returns all results of a collection. This will automatically
    # make the enumerability work as well as some methods such as
    # `first` and `length`.
    class AbstractCollection
      include Enumerable
      extend Forwardable
      def_delegators :all, :first, :each, :length

      attr_reader :connection

      # Initializes a new collection. All collections belong to a {Connection}
      # object so that is expected to be passed in as well.
      #
      # @param [Connection]
      def initialize(connection)
        @connection = connection
      end

      protected

      # A helper method to follow libvirt's API conventions to get the
      # values of an array.
      #
      # @param [Symbol] getter Getter for the array
      # @param [Symbol] count Method for getting the size of the array
      # @param [Symbol] type Type of value returned
      # @return [Array]
      def read_array(getter, count, type)
        count_max = FFI::Libvirt.send(count, connection)
        output_ptr = FFI::MemoryPointer.new(:pointer, count_max)
        count_returned = FFI::Libvirt.send(getter, connection, output_ptr, count_max)
        output_ptr.send("get_array_of_#{type}", 0, count_returned)
      end
    end
  end
end
