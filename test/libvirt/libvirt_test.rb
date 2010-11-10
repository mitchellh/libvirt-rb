require "test_helper"

Protest.describe("libvirt") do
  setup do
    @klass = Libvirt
  end

  should "provide the version" do
    assert @klass.version.is_a?(Array)
  end

  should "provide a shortcut to connecting" do
    Libvirt::Connection.expects(:new).with(1,2,3)
    @klass.connect(1,2,3)
  end
end
