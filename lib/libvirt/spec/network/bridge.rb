module Libvirt
  module Spec
    class Network
      # Represents the spec for connecting to the physical LAN using a
      # bridge.
      class Bridge
        include Util

        attr_accessor :name
        attr_accessor :stp
        attr_accessor :delay

        # Initializes a bridge specification. This should never be called
        # directly. Instead, use the {Libvirt::Spec::Network} spec, which
        # contains a bridge attribute should you choose to set it.
        def initialize(xml=nil)
          load!(xml) if xml
        end

        # Clears all information about this bridge. This causes it to not
        # appear in the XML output.
        def clear
          @name = @stp = @delay = nil
        end

        # Loads bridge information from the given XML string.
        def load!(root)
          root = Nokogiri::XML(root).root if !root.is_a?(Nokogiri::XML::Element)

          try(root.xpath("//bridge")) do |bridge|
            self.name = bridge["name"]
            self.stp = bridge["stp"] == "on" if bridge["stp"]
            self.delay = bridge["delay"].to_i if bridge["delay"]

            raise_if_unparseables(bridge.xpath("*"))
          end
        end

        # Returns the XML for this specification.
        #
        # @return [String]
        def to_xml(parent=Nokogiri::XML::Builder.new)
          options = {}
          options[:name] = name if name
          options[:stp] = stp ? "on" : "off" if !stp.nil?
          options[:delay] = delay if delay

          # No need to return an empty XML, so we just quit if there is nothing
          # to output.
          return if options.empty?

          parent.bridge(options)
          parent.to_xml
        end
      end
    end
  end
end
