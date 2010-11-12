module Libvirt
  module Collection
    # Represents a collection of network filters.
    class NWFilterCollection < AbstractCollection
      # Returns all network filters.
      #
      # @return [Array<NWFilter>]
      def all
        read_array(:virConnectListNWFilters, :virConnectNumOfNWFilters, :string).each do |name|
          # TODO
        end
      end
    end
  end
end
