require "test_helper"

Protest.describe("Graphics device spec") do
  setup do
    @klass = Libvirt::Spec::Device::Graphics
  end

  context "initialization and parsing XML" do
    should "parse the type" do
      @instance = @klass.new("<graphics type='sdl'/>")
      assert_equal :sdl, @instance.type
    end

    should "parse the display" do
      @instance = @klass.new("<graphics display='foo'/>")
      assert_equal 'foo', @instance.display
    end

    should "raise an exception if unsupported tags exist" do
      assert_raises(Libvirt::Exception::UnparseableSpec) {
        @klass.new("<graphics><foo/></graphics>")
      }
    end
  end
end
