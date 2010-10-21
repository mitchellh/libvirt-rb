require 'libvirt/spec/domain/os_booting'

module Libvirt
  module Spec
    # A specification of a domain. This translates directly down to XML
    # which can be used to define and launch domains on a node by libvirt.
    #
    # **Note:** This class may only be temporary, and the functionality
    # may be merged back into {Domain}. Also, the interface will likely
    # change.
    class Domain
      attr_accessor :hypervisor
      attr_accessor :name
      attr_accessor :uuid
      attr_accessor :description
      attr_accessor :os
      attr_accessor :memory

      def initialize
        @os = OSBooting.new
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
          end
        end.to_xml
      end
    end
  end
end
