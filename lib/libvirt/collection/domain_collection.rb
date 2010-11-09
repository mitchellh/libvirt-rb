require 'forwardable'

module Libvirt
  module Collection
    # Represents a collection of domains. This is an enumerable (in the Ruby sense)
    # object, but it is not directly an `Array`. This collection is a special enumerable
    # which allows you to do things such as get only the active domains, create a new
    # domain from a specification, etc.
    #
    # If you enumerate the entire collection, then this is equivalent to enumerating
    # over {#all} domains. e.g. `collection.length` is equivalent to calling
    # `collection.all.length` (where `collection` is a `DomainCollection` object).
    class DomainCollection
      include Enumerable
      extend Forwardable
      def_delegators :all, :first, :each, :length

      attr_reader :connection

      # Initializes a new collection of domains. For now, this method should
      # never be called directly, and is only used internally by {Connection}.
      #
      # @param [Connection] A connection object which this domain collection
      #   belongs to.
      def initialize(connection)
        @connection = connection
      end

      # Returns all the active (running) domains for the connection which this
      # collection belongs to.
      #
      # @return [Array<Domain>]
      def active
        # Do some pointer and array fiddling to extract the ids of the active
        # domains from the libvirt API
        count_max = FFI::Libvirt.virConnectNumOfDomains(connection)
        output_ptr = FFI::MemoryPointer.new(:pointer, count_max)
        count_returned = FFI::Libvirt.virConnectListDomains(connection, output_ptr, count_max)
        ids = output_ptr.get_array_of_int(0, count_returned)

        # Lookup all the IDs and make them proper Domain objects
        ids.collect do |id|
          pointer = FFI::Libvirt.virDomainLookupByID(connection, id)
          pointer.null? ? nil : Domain.new(pointer)
        end
      end

      # Returns all the inactive (not running) domains for the connection
      # which this collection belongs to.
      #
      # @return [Array<Domain>]
      def inactive
        # Do some pointer and array fiddling to extract the names of the active
        # domains from the libvirt API
        count_max = FFI::Libvirt.virConnectNumOfDefinedDomains(connection)
        output_ptr = FFI::MemoryPointer.new(:pointer, count_max)
        count_returned = FFI::Libvirt.virConnectListDefinedDomains(connection, output_ptr, count_max)
        ids = output_ptr.get_array_of_string(0, count_returned)

        # Lookup all the names and make them proper Domain objects
        ids.collect do |id|
          pointer = FFI::Libvirt.virDomainLookupByName(connection, id)
          pointer.null? ? nil : Domain.new(pointer)
        end
      end

      # Returns all domains (active and inactive) for the connection this collection
      # belongs to.
      #
      # @return [Array<Domain>]
      def all
        active + inactive
      end
    end
  end
end
