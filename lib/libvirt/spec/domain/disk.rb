require 'libvirt/spec/domain/encryptation'

module Libvirt
  module Spec
    # The Disk section of a device specification indicates to libvirt how to
    # configure any device that looks like a disk, floppy, harddisk, cdrom or paravirtualized driver.
    class Disk
      attr_accessor :type
      attr_accessor :driver
      attr_accessor :source
      attr_accessor :target
      attr_accessor :encryptation
      attr_accessor :shareable
      attr_accessor :serial

      def initialize(type, shareable = false)
        @type = type
        @shareable = shareable
        @driver, @source, @target = {}
      end

      # Convert the Disk section to its XML representation
      #
      # @return [String]
      def to_xml(parent = Nokogiri::XML::Builder.new)
        parent.disk(:type => type) do |disk|
          disk.driver(driver) unless driver.empty?
          disk.source(source)
          disk.target(target)

          encryptation.to_xml(disk) if encryptation

          disk.shareable if shareable
          disk.serial serial if serial
        end

        parent.to_xml
      end
    end
  end
end
