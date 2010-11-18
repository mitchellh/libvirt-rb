module Libvirt
  module Spec
    class Domain
      # Time keeping configuration for a domain.
      class Clock
        attr_accessor :offset

        def to_xml(parent=Nokogiri::XML::Builder.new)
          return if !offset

          parent.clock :offset => offset
          parent.to_xml
        end
      end
    end
  end
end
