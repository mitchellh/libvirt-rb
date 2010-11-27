require 'test_helper'

Protest.describe("Domain devices") do
  setup do
    @klass = Libvirt::Spec::Device
  end

  should "parse from XML" do
    @instance = @klass.load!("<disk type='file'></disk>")
    assert @instance.is_a?(Libvirt::Spec::Device::Disk)
    assert_equal :file, @instance.type
  end

  should "be able to get defined classes by name" do
    assert_equal Libvirt::Spec::Device::Disk, @klass.get(:disk)
  end

  should "raise an exception if an unknown device name is given" do
    assert_raises(NameError) { @klass.get(:foo) }
  end
end
