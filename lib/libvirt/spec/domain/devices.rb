require 'libvirt/spec/domain/characters'
require 'libvirt/spec/domain/disk'

module Libvirt
  module Spec
    # The Devices section of a domain specification indicates to libvirt how
    # to configure the pieces provided to the guest machine.
    #
    # TODO: This section is still in earlier development, these are the
    # subsections don't supported yet:
    #   1. hostdev
    #   2. interface
    #   3. video
    #   4. sound
    #
    class Devices
      attr_accessor :emulator
      attr_accessor :input
      attr_accessor :graphics
      attr_accessor :disk
      attr_accessor :serial
      attr_accessor :console
      attr_accessor :watchdog
      attr_accessor :memballoon

      def initialize
        @input, @graphics = []
        @disk = []
        @console, @serial, @parallel, @channel = []
      end

      # Convert the Devices section to its XML representation
      #
      # @return [String]
      def to_xml(parent = Nokogiri::XML::Builder.new)
        parent.devices do |devices|
          devices.emulator emulator if emulator

          input.each do |input_section|
            devices.input(input_section)
          end

          graphics.each do |graphics_section|
            devices.graphics(graphics_section)
          end

          disk.each do |disk_section|
            disk_section.to_xml(devices)
          end

          console.each do |console_section|
            console_section.to_xml(devices)
          end

          serial.each do |serial_section|
            serial_section.to_xml(devices)
          end

          parallel.each do |parallel_section|
            parallel_section.to_xml(devices)
          end

          channel.each do |channel_section|
            channel_section.to_xml(devices)
          end

          devices.watchdog(watchdog) if watchdog
          devices.memballoon(memballoon) if memballoon
        end

        parent.to_xml
      end
    end
  end
end
