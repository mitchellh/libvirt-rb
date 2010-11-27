require "test_helper"

Protest.describe("Video model device spec") do
  setup do
    @klass = Libvirt::Spec::Device::VideoModel
  end

  context "initialization and parsing XML" do
    should "parse the type" do
      @instance = @klass.new("<model type='vga'/>")
      assert_equal :vga, @instance.type
    end

    should "parse the vram" do
      @instance = @klass.new("<model vram='12'/>")
      assert_equal '12', @instance.vram
    end

    should "parse the type" do
      @instance = @klass.new("<model heads='2'/>")
      assert_equal '2', @instance.heads
    end

    should "parse the acceleration" do
      @instance = @klass.new("<model><acceleration accel3d='yes' accel2d='no'/></model>")
      assert @instance.accel3d
      assert !@instance.accel2d
    end

    should "raise an exception if unsupported tags exist" do
      assert_raises(Libvirt::Exception::UnparseableSpec) {
        @klass.new("<model><foo/></model>")
      }
    end
  end
end
