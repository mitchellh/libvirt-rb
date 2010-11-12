require "test_helper"

Protest.describe("storage pool collection") do
  setup do
    @klass = Libvirt::Collection::StoragePoolCollection
    @instance = @klass.new(Libvirt.connect("test:///default"))
  end

  should "provide a list of active storage pools" do
    active = @instance.active
    assert active.is_a?(Array)
    # assert active.all? { |a| a.is_a?(Libvirt::StoragePool) }
  end

  should "provide a list of inactive storage pools" do
    inactive = @instance.inactive
    assert inactive.is_a?(Array)
    # TODO: Create inactive storage pools to test result
  end

  should "provide a list of all storage pools" do
    assert_equal (@instance.active + @instance.inactive), @instance.all
  end
end
