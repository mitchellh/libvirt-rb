module Libvirt
  module Spec
    # The encryptation section of a disk specification indicates to libvirt
    # how the volumes attached can be encrypted.
    class Encryptation
      attr_accessor :format
      attr_accessor :secret

      def initialize(format, secret = {})
        @format = format
        @secret = secret
      end

      # Convert the Encriptation section to its XML representation
      #
      # @return [String]
      def to_xml(parent = Nokogiri::XML::Builder.new)
        parent.encryptation(:format => format) do |encryptation|
          encryptation.secret(secret)
        end

        parent.to_xml
      end
    end
  end
end
