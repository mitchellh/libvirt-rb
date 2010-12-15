module Libvirt
  module Collection
    # Represents a collection of networks. This is an enumerable (in the
    # Ruby sense) object, but it is not directly an `Array`.
    class NetworkCollection < AbstractCollection
      # Searches for a network. This will first search by name, then
      # by UUID.
      #
      # @return [Network]
      def find(value)
        result = find_by_name(value) rescue nil
        result ||= find_by_uuid(value) rescue nil
      end

      # Searches for a network by name.
      #
      # @return [Network]
      def find_by_name(name)
        nil_or_object(FFI::Libvirt.virNetworkLookupByName(interface, name), Network)
      end

      # Searches for a network by UUID.
      #
      # @return [Network]
      def find_by_uuid(uuid)
        nil_or_object(FFI::Libvirt.virNetworkLookupByUUIDString(interface, uuid), Network)
      end

      # Defines a new network with the given valid specification.
      #
      # @param [Object] spec
      # @return [Domain]
      def define(spec)
        spec = spec.is_a?(String) ? spec : spec.to_xml
        nil_or_object(FFI::Libvirt.virNetworkDefineXML(interface, spec), Network)
      end

      # Creates a new network with the given valid specification.
      #
      # @param [Object] spec
      # @return [Domain]
      def create(spec)
        spec = spec.is_a?(String) ? spec : spec.to_xml
        nil_or_object(FFI::Libvirt.virNetworkCreateXML(interface, spec), Network)
      end

      # Returns all the active networks for the connection which this
      # collection belongs to.
      #
      # @return [Array<Network>]
      def active
        read_array(:virConnectListNetworks, :virConnectNumOfNetworks, :string).collect do |name|
          find_by_name(name)
        end
      end

      # Returns all the inactive networks for the connection which this
      # collection belongs to.
      #
      # @return [Array<Network>]
      def inactive
        read_array(:virConnectListDefinedNetworks, :virConnectNumOfDefinedNetworks, :string).collect do |name|
          find_by_name(name)
        end
      end

      # Returns all networks (active and inactive) for the connection this
      # collection belongs to.
      #
      # @return [Array<Netowrk>]
      def all
        active + inactive
      end
    end
  end
end
