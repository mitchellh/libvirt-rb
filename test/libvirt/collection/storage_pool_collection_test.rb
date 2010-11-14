require "test_helper"

Protest.describe("storage pool collection") do
  setup do
    @klass = Libvirt::Collection::StoragePoolCollection
    @instance = @klass.new(Libvirt.connect("test:///default"))
  end

  context "finding" do
    should "be able to generally find" do
      assert @instance.find("default-pool")
      assert !@instance.find("foo")
    end

    should "be able to find by name" do
      assert @instance.find_by_name("default-pool")
      assert_raises(Libvirt::Exception::LibvirtError) { @instance.find_by_name("foo") }
    end

    should "be able to find by UUID" do
      # TODO: Test happy-path
      assert_raises(Libvirt::Exception::LibvirtError) { @instance.find_by_uuid("foo") }
    end
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
