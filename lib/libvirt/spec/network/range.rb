module Libvirt
  module Spec
    class Network
      # Represents a range specification for DHCP.
      class Range
        include Util

        attr_accessor :start
        attr_accessor :end

        # Initializes the specification.
        def initialize(xml=nil)
          load!(xml) if xml
        end

        # Loads the range information from the given XML string.
        def load!(root)
          root = Nokogiri::XML(root).root if !root.is_a?(Nokogiri::XML::Element)

          try(root.xpath("//range")) do |range|
            self.start = range["start"]
            self.end = range["end"]

            raise_if_unparseables(range.xpath("*"))
          end
        end

        # Returns the XML for this specification.
        #
        # @return [String]
        def to_xml(parent=Nokogiri::XML::Builder.new)
          options = {}
          options[:start] = start if start
          options[:end] = self.end if self.end # "end" is a reserved keyword

          parent.range(options)
          parent.to_xml
        end
      end
    end
  end
end
