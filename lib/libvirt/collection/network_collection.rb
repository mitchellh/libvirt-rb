module Libvirt
  module Collection
    # Represents a collection of networks. This is an enumerable (in the
    # Ruby sense) object, but it is not directly an `Array`.
    class NetworkCollection < AbstractCollection
      # Returns all the active networks for the connection which this
      # collection belongs to.
      #
      # @return [Array<Network>]
      def active
        read_array(:virConnectListNetworks, :virConnectNumOfNetworks, :string)
      end

      # Returns all the inactive networks for the connection which this
      # collection belongs to.
      #
      # @return [Array<Network>]
      def inactive
        read_array(:virConnectListDefinedNetworks, :virConnectNumOfDefinedNetworks, :string)
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
