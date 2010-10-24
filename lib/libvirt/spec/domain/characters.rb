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

      def initialize(type)
        @type = type
      end

      protected
      # Convert the Character section to its XML representation
      #
      # @return [String]
      def to_xml(element_name, parent = Nokogiri::XML::Builder.new)
        parent.send(element_name, :type => type) do |character|
          elements(character)
        end

        parent.to_xml
      end

      def elements(character)
        Array(source).each do |source_section|
          character.source(source_section)
        end if source

        character.target(target) if target
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
      attr_accessor :protocol

      # Convert the Serial section to its XML representation
      #
      # @return [String]
      def to_xml(parent = Nokogiri::XML::Builder.new)
        super('serial', parent)
      end

      def elements(character)
        super(character)
        character.protocol(protocol) if protocol
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
