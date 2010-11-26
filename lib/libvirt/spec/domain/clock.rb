module Libvirt
  module Spec
    class Domain
      # Time keeping configuration for a domain.
      class Clock
        include Util

        attr_accessor :offset

        # Initializes a clock specification. This should never be called
        # directly. Instead, use a {Libvirt::Spec::Domain} spec, which
        # contains a clock attribute.
        def initialize(xml=nil)
          load!(xml) if xml
        end

        # Loads clock information from the given XML string. This shouldn't
        # be called directly, since the domain spec automatically calls
        # this.
        def load!(root)
          try(root.xpath("//clock[@offset]")) { |result| self.offset = result["offset"].to_sym }
          raise_if_unparseables(root.xpath("//clock/*"))
        end

        def to_xml(parent=Nokogiri::XML::Builder.new)
          return if !offset

          parent.clock :offset => offset
          parent.to_xml
        end
      end
    end
  end
end
