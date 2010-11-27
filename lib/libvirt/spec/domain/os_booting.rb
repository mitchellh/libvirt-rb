module Libvirt
  module Spec
    class Domain
      # The OS booting section of a domain specification indicates to libvirt
      # how to configure the virtual machine to boot. There are three main ways
      # to configure booting. Each hypervisor supports one or more of the following:
      #
      # 1. BIOS bootloader
      # 2. Host bootloader
      # 3. Direct kernel boot
      #
      # TODO: Host bootloader and direct kernel bootloader options.
      class OSBooting
        include Util

        attr_accessor :type
        attr_accessor :arch
        attr_accessor :loader # Part of the BIOS bootloader
        attr_accessor :boot
        attr_accessor :bootmenu_enabled

        # Host bootloader configuration options
        attr_accessor :bootloader
        attr_accessor :bootloader_args

        # Direct kernel boot
        attr_accessor :kernel
        attr_accessor :initrd
        attr_accessor :cmdline

        # Initializes an OS booting specification. This shouldn't be
        # called directly since the domain spec automatically loads
        # this.
        def initialize(xml=nil)
          @boot = []

          load!(xml) if xml
        end

        # Enables or disables the interactive boot menu prompt on guest startup.
        def bootmenu_enabled=(value)
          # Force a boolean value
          @bootmenu_enabled = !!value
        end

        # Loads the OS booting information from the given XML string. This
        # shouldn't be called directly, since the domain spec automatically
        # calls this.
        def load!(root)
          root = Nokogiri::XML(root).root if !root.is_a?(Nokogiri::XML::Element)
          try(root.xpath("//os/type[@arch]"), :preserve => true) { |result| self.arch = result["arch"].to_sym }
          try(root.xpath("//os/type")) { |result| self.type = result.text.to_sym }

          try(root.xpath("//os/boot"), :multi => true) do |results|
            self.boot = []

            results.each do |result|
              self.boot << result["dev"].to_sym
            end
          end

          raise_if_unparseables(root.xpath("//os/*"))
        end

        # Convert just the OS booting section to its XML representation.
        def to_xml(parent=Nokogiri::XML::Builder.new)
          parent.os do |os|
            # Build the arguments for the OS booting type
            type_args = [type]
            type_args << { :arch => arch } if arch

            # Setup the specification
            os.type_ *type_args
            os.loader loader if loader
            os.bootmenu(:enable => bootmenu_enabled ? 'yes' : 'no') if !bootmenu_enabled.nil?

            # Boot order for BIOS booting
            boot.each { |dev| os.boot :dev => dev } if boot.is_a?(Array)

            # Host bootloader configuration options
            os.bootloader bootloader if bootloader
            os.bootloader_args bootloader_args if bootloader_args

            # Direct kernel boot options
            os.kernel kernel if kernel
            os.initrd initrd if initrd
            os.cmdline cmdline if cmdline
          end

          parent.to_xml
        end
      end
    end
  end
end
