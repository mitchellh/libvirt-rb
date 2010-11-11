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
    class DomainCollection < AbstractCollection
      # Defines a new domain with the given valid specification. This method
      # doesn't start the domain.
      #
      # @param [Object] spec
      # @return [Domain]
      def define(spec)
        ptr = FFI::Libvirt.virDomainDefineXML(connection, spec.to_xml)
        ptr.null? ? nil : Domain.new(ptr)
      end

      # Returns all the active (running) domains for the connection which this
      # collection belongs to.
      #
      # @return [Array<Domain>]
      def active
        # Do some pointer and array fiddling to extract the ids of the active
        # domains from the libvirt API
        ids = read_array(:virConnectListDomains, :virConnectNumOfDomains, :int)

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
        ids = read_array(:virConnectListDefinedDomains, :virConnectNumOfDefinedDomains, :string)

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
