module Libvirt
  module Spec
    module Device
      # Represents an input device, which is a device that allows
      # interaction with the graphical framebuffer in the guest
      # virtual machine.
      class Input
        include Util

        attr_accessor :type
        attr_accessor :bus

        # Initializes a new input device. If an XML string is given,
        # it will be used to attempt to initialize the attributes.
        def initialize(xml=nil)
          load!(xml) if xml
        end

        # Attempts to initialize object attributes based on the XML
        # string given.
        def load!(xml)
          xml = Nokogiri::XML(xml).root if !xml.is_a?(Nokogiri::XML::Element)
          try(xml.xpath("//input[@type]"), :preserve => true) { |result| self.type = result["type"].to_sym }
          try(xml.xpath("//input[@bus]"), :preserve => true) { |result| self.bus = result["bus"].to_sym }

          raise_if_unparseables(xml.xpath("//input/*"))
        end

        # Returns the XML representation of this device
        def to_xml(xml=Nokogiri::XML::Builder.new)
          options = { :type => type }
          options[:bus] = bus if bus

          xml.input(options)
          xml.to_xml
        end
      end
    end
  end
end
