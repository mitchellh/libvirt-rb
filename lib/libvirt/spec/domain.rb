require 'libvirt/spec/domain/clock'
require 'libvirt/spec/domain/memtune'
require 'libvirt/spec/domain/os_booting'

module Libvirt
  module Spec
    # A specification of a domain. This translates directly down to XML
    # which can be used to define and launch domains on a node by libvirt.
    class Domain
      attr_accessor :hypervisor
      attr_accessor :name
      attr_accessor :uuid
      attr_accessor :description
      attr_accessor :os
      attr_accessor :memory
      attr_accessor :current_memory
      attr_accessor :memory_backing
      attr_accessor :memtune
      attr_accessor :vcpu
      attr_accessor :features

      attr_accessor :on_poweroff
      attr_accessor :on_reboot
      attr_accessor :on_crash

      attr_accessor :clock
      attr_accessor :devices

      def initialize
        @os = OSBooting.new
        @memtune = Memtune.new
        @features = []
        @clock = Clock.new
        @devices = []
      end

      # Returns the XML for this specification. This XML may be passed
      # into libvirt to create a domain. This is actually the method which
      # should be used for validation of this XML, since libvirt has
      # great validation built in. If you define a domain and an error occurs,
      # then it will notify you what is missing or wrong with the specification.
      #
      # @return [String]
      def to_xml
        Nokogiri::XML::Builder.new do |xml|
          xml.domain(:type => hypervisor) do
            # Name and description
            xml.name name if name
            xml.uuid uuid if uuid
            xml.description description if description

            # Operating system boot information
            os.to_xml(xml)

            # Basic resources
            xml.memory memory if memory
            xml.currentMemory current_memory if current_memory
            xml.vcpu vcpu if vcpu

            if memory_backing == :huge_pages
              xml.memoryBacking do
                xml.hugepages
              end
            end

            # Memtune handles whether or not to render itself
            memtune.to_xml(xml)

            if !features.empty?
              xml.features do
                features.each do |feature|
                  xml.send(feature)
                end
              end
            end

            # Lifecycle control
            xml.on_poweroff on_poweroff if on_poweroff
            xml.on_reboot on_reboot if on_reboot
            xml.on_crash on_crash if on_crash

            # Clock
            clock.to_xml(xml)

            # Devices
            if !devices.empty?
              xml.devices do
                devices.map { |d| d.to_xml(xml) }
              end
            end
          end
        end.to_xml
      end
    end
  end
end
