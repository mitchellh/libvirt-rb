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
      # Searches for a domain. This will search first by name, then by ID,
      # then by UUID, returning a result as soon as one is found.
      #
      # @return [Domain]
      def find(value)
        result = find_by_name(value) rescue nil
        result ||= find_by_id(value) rescue nil
        result ||= find_by_uuid(value) rescue nil
      end

      # Searches for a domain by name.
      #
      # @return [Domain]
      def find_by_name(name)
        nil_or_object(FFI::Libvirt.virDomainLookupByName(interface, name), Domain)
      end

      # Searches for a domain by ID.
      #
      # @return [Domain]
      def find_by_id(id)
        nil_or_object(FFI::Libvirt.virDomainLookupByID(interface, id), Domain)
      end

      # Searches for a domain by UUID.
      #
      # @return [Domain]
      def find_by_uuid(uuid)
        nil_or_object(FFI::Libvirt.virDomainLookupByUUIDString(interface, uuid), Domain)
      end

      # Defines a new domain with the given valid specification. This method
      # doesn't start the domain.
      #
      # @param [Object] spec
      # @return [Domain]
      def define(spec)
        spec = spec.is_a?(String) ? spec : spec.to_xml
        nil_or_object(FFI::Libvirt.virDomainDefineXML(interface, spec), Domain)
      end

      # Creates a new domain and starts it. This domain configuration is not
      # persisted, so it may disappear after the next reboot or shutdown.
      #
      # @param [Object] spec
      # @return [Domain]
      def create(spec)
        spec = spec.is_a?(String) ? spec : spec.to_xml
        nil_or_object(FFI::Libvirt.virDomainCreateXML(interface, spec, 0), Domain)
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
        ids.collect { |id| find_by_id(id) }
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
        ids.collect { |id| find_by_name(id) }
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
