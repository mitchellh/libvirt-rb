require "test_helper"

Protest.describe("Input device spec") do
  setup do
    @klass = Libvirt::Spec::Device::Input
  end

  context "initialization and parsing XML" do
    should "parse the type" do
      @instance = @klass.new("<input type='mouse'>")
      assert_equal :mouse, @instance.type
    end

    should "parse the bus" do
      @instance = @klass.new("<input bus='usb'>")
      assert_equal :usb, @instance.bus
    end

    should "raise an exception if unsupported tags exist" do
      assert_raises(Libvirt::Exception::UnparseableSpec) {
        @klass.new("<input><foo/></input>")
      }
    end
  end
end
