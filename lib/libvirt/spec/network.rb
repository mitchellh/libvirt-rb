require 'libvirt/spec/network/bridge'
require 'libvirt/spec/network/ip'

module Libvirt
  module Spec
    # A specification of a network interface. This translates directly
    # down to XML which can be used to define network interfaces.
    class Network
      include Util

      attr_accessor :name
      attr_accessor :uuid
      attr_accessor :bridge
      attr_accessor :ip

      # Initializes a network specification. If a valid XML string is
      # given, it will attempt to be parsed into the structure.
      def initialize(xml=nil)
        @bridge = Bridge.new
        @ip = IP.new

        load!(xml) if xml
      end

      # Attempts to load the attributes from an XML specification.
      #
      # @param [String] xml XML spec to attempt to parse into the structure.
      def load!(xml)
        root = Nokogiri::XML(xml).root
        try(root.xpath("//network")) do |network|
          try(network.xpath("name")) { |result| self.name = result.text }
          try(network.xpath("uuid")) { |result| self.uuid = result.text }
          try(network.xpath("bridge")) { |result| self.bridge = Bridge.new(result) }
          try(network.xpath("ip")) { |result| self.ip = IP.new(result) }
        end
      end

      # Returns the XML for this specification.
      #
      # @return [String]
      def to_xml
        Nokogiri::XML::Builder.new do |xml|
          xml.network do
            xml.name name if name
            xml.uuid uuid if uuid

            bridge.to_xml(xml)
          end
        end.to_xml
      end
    end
  end
end

