require "test_helper"

Protest.describe("libvirt") do
  setup do
    @klass = Libvirt
  end

  should "provide the version" do
    assert @klass.version.is_a?(Array)
  end
end
