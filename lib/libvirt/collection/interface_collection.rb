module Libvirt
  module Collection
    # Represents a collection of interfaces. This is an enumerable (in the
    # Ruby sense) object, but it is not directly an `Array`.
    class InterfaceCollection < AbstractCollection
      # Returns all the active interfaces for the connection which this
      # collection belongs to.
      #
      # @return [Array<Interface>]
      def active
        # TODO: Doesn't work on mac :) must dev on linux
        # read_array(:virConnectListInterfaces, :virConnectNumOfInterfaces, :string)
      end
    end
  end
end
