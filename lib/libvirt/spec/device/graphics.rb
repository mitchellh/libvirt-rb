module Libvirt
  module Spec
    module Device
      # Represents a graphics device, which allows for graphical
      # interaction with the guest OS.
      class Graphics
        include Util

        attr_accessor :type
        attr_accessor :display

        # Initializes a new graphics device. If an XML string is given,
        # it will be used to attempt to initialize the attributes.
        def initialize(xml=nil)
          load!(xml) if xml
        end

        # Attempts to initialize object attributes based on the XML
        # string given.
        def load!(xml)
          xml = Nokogiri::XML(xml).root if !xml.is_a?(Nokogiri::XML::Element)
          try(xml.xpath("//graphics[@type]"), :preserve => true) { |result| self.type = result["type"].to_sym }
          try(xml.xpath("//graphics[@display]"), :preserve => true) { |result| self.display = result["display"] }

          raise_if_unparseables(xml.xpath("//graphics/*"))
        end

        # Returns the XML representation of this device.
        def to_xml(xml=Nokogiri::XML::Builder.new)
          options = { :type => type }
          options[:display] = display if display

          xml.graphics(options)
          xml.to_xml
        end
      end
    end
  end
end
