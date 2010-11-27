module Libvirt
  module Spec
    module Device
      # Represents a network interface device which is attached to
      # a domain.
      class Interface
        include Util

        attr_accessor :type
        attr_accessor :mac_address
        attr_accessor :model_type
        attr_accessor :source_network

        # Initializes a new network interface device. If an XML string
        # is given, it will be used to attempt to initialize the attributes.
        def initialize(xml=nil)
          load!(xml) if xml
        end

        # Attempts to initialize object attributes based on XML attributes.
        def load!(xml)
          xml = Nokogiri::XML(xml).root if !xml.is_a?(Nokogiri::XML::Element)
          try(xml.xpath("//interface")) do |interface|
            self.type = interface["type"].to_sym if interface["type"]
            try(interface.xpath("mac")) { |result| self.mac_address = result["address"] }
            try(interface.xpath("model")) { |result| self.model_type = result["type"] }
            try(interface.xpath("source")) do |result|
              self.source_network = result["network"]
            end

            raise_if_unparseables(interface.xpath("*"))
          end
        end

        # Returns the XML representation of this device
        def to_xml(xml=Nokogiri::XML::Builder.new)
          xml.interface(:type => type) do |i|
            i.mac(:address => mac_address) if mac_address
            i.model(:type => model_type) if model_type
          end

          xml.to_xml
        end
      end
    end
  end
end
