module Libvirt
  module Spec
    # Utility methods for the spec classes. This module is typically
    # included for each class.
    module Util
      # Tries the given XML search, running the block if there are any
      # results. This allows a concise syntax for loading data from
      # XML which may or may not exist.
      #
      # @param [Array] search_result
      def try(search_result)
        return if search_result.empty?
        yield search_result.first
      end
    end
  end
end
