require 'test_helper'

Protest.describe("Domain OS booting spec") do
  setup do
    @klass = Libvirt::Spec::Domain::OSBooting
  end

  context "initialization and parsing XML" do
    should "parse the type" do
      @instance = @klass.new("<os><type>hvm</type></os>")
      assert_equal :hvm, @instance.type
    end

    should "parse the architecture" do
      @instance = @klass.new("<os><type arch='i386'>hvm</type></os>")
      assert_equal :i386, @instance.arch
    end
  end
end
