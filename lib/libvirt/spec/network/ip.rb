require 'libvirt/spec/network/dhcp'

module Libvirt
  module Spec
    class Network
      # Represents the spec for the IP section of a network spec.
      class IP
        include Util

        attr_accessor :address
        attr_accessor :netmask
        attr_accessor :dhcp

        # Initializes the IP specification. This should never be called
        # directly. Instead, use the {Libvirt::Spec::Network} spec, which
        # contains an `ip` attribute.
        def initialize(xml=nil)
          @dhcp = DHCP.new

          load!(xml) if xml
        end

        # Loads IP information from the given XML string.
        def load!(root)
          root = Nokogiri::XML(root).root if !root.is_a?(Nokogiri::XML::Element)

          try(root.xpath("//ip")) do |ip|
            self.address = ip["address"]
            self.netmask = ip["netmask"]

            try(ip.xpath("dhcp")) { |result| self.dhcp = DHCP.new(result) }

            raise_if_unparseables(ip.xpath("*"))
          end
        end

        # Returns the XML for this specification.
        #
        # @return [String]
        def to_xml(parent=Nokogiri::XML::Builder.new)
          options = {}
          options[:address] = address if address
          options[:netmask] = netmask if netmask

          parent.ip(options) do |ip|
            dhcp.to_xml(ip)
          end

          parent.to_xml
        end
      end
    end
  end
end
