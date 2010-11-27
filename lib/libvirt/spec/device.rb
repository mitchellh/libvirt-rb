module Libvirt
  module Spec
    module Device
      autoload :Disk, 'libvirt/spec/device/disk'
      autoload :Emulator, 'libvirt/spec/device/emulator'

      # Loads a device from an XML string. This will automatically find
      # the proper class to load and return that.
      #
      # @return [Device]
      def self.load!(xml)
        xml = Nokogiri::XML(xml).root if !xml.is_a?(Nokogiri::XML::Element)
        get(xml.name).new(xml)
      end

      # Returns the class of a device based on the name. If
      # `:disk` were given, for example, then a {Disk} class
      # would be returned. Note that since the class is returned,
      # and not an instance, it is up to the caller to instantiate
      # the returned class.
      #
      # @param [Symbol] name
      # @return [Class]
      def self.get(name)
        const_get(name.to_s.capitalize)
      end
    end
  end
end
