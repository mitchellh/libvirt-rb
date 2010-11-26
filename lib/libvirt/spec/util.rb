module Libvirt
  module Spec
    # Utility methods for the spec classes. This module is typically
    # included for each class.
    module Util
      # Tries the given XML search, running the block if there are any
      # results. This allows a concise syntax for loading data from
      # XML which may or may not exist.
      #
      # **Warning:** By default, the result of the search given will
      # be removed from the XML tree. See the options below for information
      # on how to avoid this.
      #
      # An additional parameter supports options given as a hash. This
      # allows for the following to be set:
      #
      #   * `multi` - If true, then all results will be returned, not just
      #     the first one.
      #   * `preserve` - If true, then the node will not be deleted after
      #     yielding to the block.
      #
      # @param [Array] search_result
      # @param [Hash] options Additional options, which are outlined
      #   above.
      def try(search_result, options=nil)
        options ||= {}
        return if search_result.empty?
        search_result = search_result.first if !options[:multi]
        yield search_result
        search_result.remove if !options[:preserve]
      end
    end
  end
end
