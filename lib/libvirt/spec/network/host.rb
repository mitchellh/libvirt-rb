module Libvirt
  module Spec
    class Network
      # Represents the specification for a DHCP host subsection.
      class Host
        include Util

        attr_accessor :mac
        attr_accessor :name
        attr_accessor :ip

        # Initializes the Host specification. This should never be called
        # directly. Instead, use the {Libvirt::Spec::DHCP} spec which has
        # helper methods to add a host.
        def initialize(xml=nil)
          load!(xml) if xml
        end

        # Loads the host information from the given XML string.
        def load!(root)
          root = Nokogiri::XML(root).root if !root.is_a?(Nokogiri::XML::Element)

          try(root.xpath("//host")) do |host|
            self.mac = host["mac"]
            self.name = host["name"]
            self.ip = host["ip"]

            raise_if_unparseables(host.xpath("*"))
          end
        end

        # Returns the XML for this specification.
        #
        # @return [String]
        def to_xml(parent=Nokogiri::XML::Builder.new)
          options = {}
          options[:mac] = mac if mac
          options[:name] = name if name
          options[:ip] = ip if ip

          parent.host(options)
          parent.to_xml
        end
      end
    end
  end
end
