module FFI
  module Libvirt
    attach_function :virGetVersion, [:unsigned_long_pointer, :string, :unsigned_long_pointer], :int

    class << self
      # Returns the version of libvirt client on this machine. The
      # version is returned as an array of `[major, minor, patch]`.
      #
      # @return [Array]
      def version
        Util.parse_version_number(raw_version)
      end

      protected

      # Returns the version of libvirt as the raw integer version, such as
      # 8004 (which is actually "0.8.4"). This is used internally to do fast
      # version comparisons.
      #
      # @return [Integer]
      def raw_version
        out = FFI::MemoryPointer.new(:ulong)
        FFI::Libvirt.virGetVersion(out, nil, nil)
        out.get_ulong(0)
      end

      # Allows the scoping of certain FFI attaches to specific versions of
      # libvirt. This allows the FFI library to work from early versions of
      # libvirt through to later versions.
      def libvirt_version(string_version, &block)
        # Convert the given version to the proper numerical representation so
        # it is more easily compared.
        multiplier = 1_000_000
        numeric_version = string_version.split(".").inject(0) do |acc, part|
          acc += part.to_i * multiplier
          multiplier /= 1000
          acc
        end

        # If the version we have is newer, then eval the block, since we
        # support it.
        instance_eval(&block) if raw_version >= numeric_version
      end
    end
  end
end
