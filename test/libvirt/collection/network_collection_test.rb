require "test_helper"

Protest.describe("network collection") do
  setup do
    @klass = Libvirt::Collection::NetworkCollection
    @instance = @klass.new(Libvirt.connect("test:///default"))
  end

  should "provide a list of active networks" do
    active = @instance.active
    assert active.is_a?(Array)
    assert active.all? { |a| a.is_a?(Libvirt::Network) }
  end

  should "provide a list of inactive networks" do
    inactive = @instance.inactive
    assert inactive.is_a?(Array)
    # TODO: Create inactive networks to test result
  end

  should "provide a list of all networks" do
    assert_equal (@instance.active + @instance.inactive), @instance.all
  end
end
