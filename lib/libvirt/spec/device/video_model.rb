module Libvirt
  module Spec
    module Device
      # Represents a model in the specific video device.
      class VideoModel
        include Util

        attr_accessor :type
        attr_accessor :vram
        attr_accessor :heads
        attr_accessor :accel3d
        attr_accessor :accel2d

        # Initializes a new video model device. If an XML string is
        # given, it will be used to attempt to initialize the attributes.
        def initialize(xml=nil)
          load!(xml) if xml
        end

        # Attempts to initialize object attributes based on the XML
        # strings given.
        def load!(xml)
          xml = Nokogiri::XML(xml).root if !xml.is_a?(Nokogiri::XML::Element)
          try(xml.xpath("//model[@type]"), :preserve => true) { |result| self.type = result["type"].to_sym }
          try(xml.xpath("//model[@vram]"), :preserve => true) { |result| self.vram = result["vram"] }
          try(xml.xpath("//model[@heads]"), :preserve => true) { |result| self.heads = result["heads"] }
          try(xml.xpath("//model/acceleration")) do |result|
            self.accel3d = result["accel3d"] == "yes"
            self.accel2d = result["accel2d"] == "yes"
          end

          raise_if_unparseables(xml.xpath("//model/*"))
        end
      end
    end
  end
end
