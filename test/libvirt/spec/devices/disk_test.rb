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

    should "raise an exception if unsupported tags exist" do
      assert_raises(Libvirt::Exception::UnparseableSpec) {
        @klass.new("<disk><foo/></disk>")
      }
    end
  end
end
