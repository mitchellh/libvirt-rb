module Libvirt
  module Spec
    class Domain
      # Allows the modification of details regarding the memory tuneable
      # parameters for this domain.
      class Memtune
        attr_accessor :hard_limit
        attr_accessor :soft_limit
        attr_accessor :swap_hard_limit
        attr_accessor :min_guarantee

        def to_xml(parent=Nokogiri::XML::Builder.new)
          # If nothing has been modified, then don't do anything
          return if !hard_limit && !soft_limit &&
                    !swap_hard_limit && !min_guarantee

          parent.memtune do |m|
            m.hard_limit hard_limit if hard_limit
            m.soft_limit soft_limit if soft_limit
            m.swap_hard_limit swap_hard_limit if swap_hard_limit
            m.min_guarantee min_guarantee if min_guarantee
          end

          parent.to_xml
        end
      end
    end
  end
end
