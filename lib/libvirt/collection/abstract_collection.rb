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
      def_delegators :all, :first, :last, :each, :length, :[], :inspect, :to_s

      attr_reader :interface

      # Initializes a new collection. All collections belong to a parent
      # structure in some way, which is expected to be passed in here.
      #
      # @param [Object] Parent object
      def initialize(interface)
        @interface = interface
      end

      protected

      # A helper method to follow libvirt's API conventions to get the
      # values of an array.
      #
      # @param [Symbol] getter Getter for the array
      # @param [Symbol] count Method for getting the size of the array
      # @param [Symbol] type Type of value returned
      # @return [Array]
      def read_array(getter, counter, type)
        count_max = FFI::Libvirt.send(counter, interface)
        output_ptr = FFI::MemoryPointer.new(:pointer, count_max)
        count_returned = FFI::Libvirt.send(getter, interface, output_ptr, count_max)
        output_ptr.send("get_array_of_#{type}", 0, count_returned)
      end
    end
  end
end
