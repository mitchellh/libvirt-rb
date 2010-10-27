require "test_helper"

Protest.describe("Emulator device spec") do
  setup do
    @klass = Libvirt::Spec::Device::Emulator
  end

  should "have the given path when initialized" do
    path = "foo"
    instance = @klass.new(path)
    assert_equal path, instance.path
  end

  should "output XML with the given path" do
    path = "foo"
    instance = @klass.new(path)

    assert_xpath path, instance.to_xml, "//emulator"
  end
end
