require "test_helper"

Protest.describe("storage volume collection") do
  setup do
    @klass = Libvirt::Collection::StorageVolumeCollection
    @instance = @klass.new(Libvirt.connect("test:///default").storage_pools.first)
  end

  should "provide a list of all volumes" do
    all = @instance.all
    assert all.is_a?(Array)
  end
end
