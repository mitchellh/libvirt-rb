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

        # Initializes a new network interface device. If an XML string
        # is given, it will be used to attempt to initialize the attributes.
        def initialize(xml=nil)
          load!(xml) if xml
        end

        # Attempts to initialize object attributes based on XML attributes.
        def load!(xml)
          xml = Nokogiri::XML(xml).root if !xml.is_a?(Nokogiri::XML::Element)
          try(xml.xpath("//interface[@type]"), :preserve => true) { |result| self.type = result["type"].to_sym }
          try(xml.xpath("//interface/mac")) { |result| self.mac_address = result["address"] }
          try(xml.xpath("//interface/model")) { |result| self.model_type = result["type"] }

          raise_if_unparseables(xml.xpath("//interface/*"))
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
