module Libvirt
  module Spec
    module Device
      # Represents a sound device.
      class Sound
        include Util

        attr_accessor :model

        # Initializes a new sound device. If an XML string is given,
        # it will be used to attempt to initialize the attributes.
        def initialize(xml=nil)
          load!(xml) if xml
        end

        # Attempts to initialize object attributes based on the XML
        # string given.
        def load!(xml)
          xml = Nokogiri::XML(xml).root if !xml.is_a?(Nokogiri::XML::Element)
          try(xml.xpath("//sound[@model]"), :preserve => true) { |result| self.model = result["model"].to_sym }
          raise_if_unparseables(xml.xpath("//sound/*"))
        end

        # Returns the XML representation of this device.
        def to_xml(xml=Nokogiri::XML::Builder.new)
          xml.sound(:model => model)
          xml.to_xml
        end
      end
    end
  end
end
