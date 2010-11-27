require "test_helper"

Protest.describe("Disk device spec") do
  setup do
    @klass = Libvirt::Spec::Device::Disk
  end

  context "initialization and parsing XML" do
    should "parse the type" do
      @instance = @klass.new("<disk type='file'></disk>")
      assert_equal :file, @instance.type
    end

    should "parse the device attribute" do
      @instance = @klass.new("<disk device='disk'></disk>")
      assert_equal :disk, @instance.device
    end

    should "parse the file from the source" do
      @instance = @klass.new("<disk type='file'><source file='foo'/></disk>")
      assert_equal 'foo', @instance.source
    end

    should "parse the dev from the source" do
      @instance = @klass.new("<disk type='file'><source dev='bar'/></disk>")
      assert_equal 'bar', @instance.source
    end

    should "parse the target" do
      @instance = @klass.new("<disk type='file'><target bus='foo' dev='bar'/></disk>")
      assert_equal 'foo', @instance.target_bus
      assert_equal 'bar', @instance.target_dev
    end

    should "raise an exception if unsupported tags exist" do
      assert_raises(Libvirt::Exception::UnparseableSpec) {
        @klass.new("<disk><foo/></disk>")
      }
    end
  end
end
