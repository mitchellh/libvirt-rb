module Libvirt
  module Spec
    module Device
      # Any device that looks like a disk, be it a floppy, harddisk,
      # cdrom, or paravirtualized driver is specified via the disk
      # element.
      class Disk
        include Util

        attr_accessor :type
        attr_accessor :device
        attr_accessor :source
        attr_accessor :target_dev
        attr_accessor :target_bus
        attr_accessor :driver
        attr_accessor :driver_type
        attr_accessor :driver_cache
        attr_accessor :shareable
        attr_accessor :serial

        # Initializes a new disk element. If an XML string is passed
        # then that will be used to initialize the attributes of the
        # device.
        def initialize(xml)
          @shareable = false

          load!(xml) if xml
        end

        # Loads data from XML.
        def load!(xml)
          xml = Nokogiri::XML(xml).root if !xml.is_a?(Nokogiri::XML::Element)
          try(xml.xpath("//disk[@type]"), :preserve => true) { |result| self.type = result["type"].to_sym }
          try(xml.xpath("//disk[@device]"), :preserve => true) { |result| self.device = result["device"].to_sym }
          try(xml.xpath("//disk/source")) { |result| self.source = result["dev"] || result["file"] }

          try(xml.xpath("//disk/target")) do |result|
            self.target_dev = result["dev"]
            self.target_bus = result["bus"]
          end

          raise_if_unparseables(xml.xpath("//disk/*"))
        end

        # Returns the XML representation of this device.
        def to_xml(xml=Nokogiri::XML::Builder.new)
          xml.disk(:type => type, :device => device) do |d|
            if source
              # Source tag, the attribute depends on the type.
              attribute = type == :block ? :dev : :file
              d.source(attribute => source)
            end

            if target_dev
              # Target tag has optional "bus" parameter
              options = { :dev => target_dev }
              options[:bus] = target_bus if target_bus
              d.target(options)
            end

            if driver
              # Driver tag has a couple optional parameters
              options = { :name => driver }
              options[:type] = driver_type if driver_type
              options[:cache] = driver_cache if driver_cache
              d.driver(options)
            end

            d.shareable if shareable
            d.serial serial if serial
          end

          xml.to_xml
        end
      end
    end
  end
end
