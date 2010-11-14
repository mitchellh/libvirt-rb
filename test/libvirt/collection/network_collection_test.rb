require "test_helper"

Protest.describe("network collection") do
  setup do
    @klass = Libvirt::Collection::NetworkCollection
    @instance = @klass.new(Libvirt.connect("test:///default"))
  end

  context "finding" do
    should "be able to find by name or UUID" do
      assert @instance.find("default")
      assert !@instance.find("foo")
    end

    should "be able to find by name" do
      assert @instance.find_by_name("default")
      assert_raises(Libvirt::Exception::LibvirtError) {  @instance.find_by_name("foo") }
    end

    should "be able to find by UUID" do
      assert_raises(Libvirt::Exception::LibvirtError) { @instance.find_by_uuid("bad") }
      # TODO: Test successful case
    end
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
