module Libvirt
  module Spec
    module Device
      # Represents a video device.
      class Video
        include Util

        attr_accessor :models

        # Initializes a new video device. If an XML string is given,
        # it will be used to attempt to initialize the attributes.
        def initialize(xml=nil)
          load!(xml) if xml
        end

        # Attempts to initialize object attributes based on the XML
        # string given.
        def load!(xml)
          xml = Nokogiri::XML(xml).root if !xml.is_a?(Nokogiri::XML::Element)

          try(xml.xpath("//video/model"), :multi => true) do |result|
            self.models = []

            result.each do |model|
              self.models << VideoModel.new(model)
            end
          end

          raise_if_unparseables(xml.xpath("//video/*"))
        end
      end
    end
  end
end
