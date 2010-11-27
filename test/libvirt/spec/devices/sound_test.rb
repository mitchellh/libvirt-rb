require "test_helper"

Protest.describe("Sound device spec") do
  setup do
    @klass = Libvirt::Spec::Device::Sound
  end

  context "initialization and parsing XML" do
    should "parse the model" do
      @instance = @klass.new("<sound model='ac97'/>")
      assert_equal :ac97, @instance.model
    end

    should "raise an exception if unsupported tags exist" do
      assert_raises(Libvirt::Exception::UnparseableSpec) {
        @klass.new("<sound><foo/></sound>")
      }
    end
  end
end
