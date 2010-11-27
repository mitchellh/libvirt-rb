require "test_helper"

Protest.describe("Interface device spec") do
  setup do
    @klass = Libvirt::Spec::Device::Interface
  end

  context "initialization and parsing XML" do
    should "parse the type" do
      @instance = @klass.new("<interface type='user'></interface>")
      assert_equal :user, @instance.type
    end

    should "parse the MAC address" do
      @instance = @klass.new("<interface><mac address='foo'/></interface>")
      assert_equal 'foo', @instance.mac_address
    end

    should "parse the model type" do
      @instance = @klass.new("<interface><model type='foo'/></interface>")
      assert_equal 'foo', @instance.model_type
    end

    should "parse the source from a network" do
      @instance = @klass.new("<interface><source network='foo'/></interface>")
      assert_equal 'foo', @instance.source_network
    end

    should "raise an exception if unsupported tags exist" do
      assert_raises(Libvirt::Exception::UnparseableSpec) {
        @klass.new("<interface><foo/></interface>")
      }
    end
  end
end
