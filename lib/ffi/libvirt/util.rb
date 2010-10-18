module FFI
  module Libvirt
    module Util
      # Parses the raw version integer returned by various libvirt methods
      # into proper `[major, minor, patch]` format.
      #
      # @return [Array]
      def self.parse_version_number(number)
        # Format is MAJOR * 1,000,000 + MINOR * 1,000 + PATCH
        major = number / 1_000_000
        number %= 1_000_000
        minor = number / 1_000
        number %= 1000
        [major, minor, number]
      end
    end
  end
end
