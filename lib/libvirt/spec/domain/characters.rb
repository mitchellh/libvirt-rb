module Libvirt
  module Spec
    # The character devices provide a different ways to interact with the
    # virtual machine.
    #
    # There are four different representations that have to be used rather
    # than Character.
    class Character
      attr_accessor :type
      attr_accessor :source
      attr_accessor :target

      def initialize(type, source = {}, target = {})
        @type = type
        @source = source
        @target = target
      end

      protected
      # Convert the Character section to its XML representation
      #
      # @return [String]
      def to_xml(element_name, parent = Nokogiri::XML::Builder.new)
        parent.send(element_name, :type => type) do |character|
          character.source(@source)
          character.target(@target)
        end

        parent.to_xml
      end
    end

    class Console < Character
      # Convert the Console section to its XML representation
      #
      # @return [String]
      def to_xml(parent = Nokogiri::XML::Builder.new)
        super('console', parent)
      end
    end

    class Serial < Character
      # Convert the Serial section to its XML representation
      #
      # @return [String]
      def to_xml(parent = Nokogiri::XML::Builder.new)
        super('serial', parent)
      end
    end

    class Parallel < Character
      # Convert the Parallel section to its XML representation
      #
      # @return [String]
      def to_xml(parent = Nokogiri::XML::Builder.new)
        super('parallel', parent)
      end
    end

    class Channel < Character
      # Convert the Channel section to its XML representation
      #
      # @return [String]
      def to_xml(parent = Nokogiri::XML::Builder.new)
        super('channel', parent)
      end
    end
  end
end
