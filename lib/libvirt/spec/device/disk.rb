module Libvirt
  module Spec
    module Device
      # Any device that looks like a disk, be it a floppy, harddisk,
      # cdrom, or paravirtualized driver is specified via the disk
      # element.
      class Disk
        attr_accessor :type
        attr_accessor :source
        attr_accessor :target_dev
        attr_accessor :target_bus
        attr_accessor :driver
        attr_accessor :driver_type
        attr_accessor :driver_cache
        attr_accessor :shareable
        attr_accessor :serial

        # Initialize a new disk element with the given type. Examples
        # of valid `type`s are "disk," "floppy," and "cdrom."
        def initialize(type)
          @type = type
          @shareable = false
        end

        # Returns the XML representation of this device.
        def to_xml(xml=Nokogiri::XML::Builder.new)
          xml.disk(:type => type) do |d|
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
