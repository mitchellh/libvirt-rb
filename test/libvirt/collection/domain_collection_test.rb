require "test_helper"

Protest.describe("domain collection") do
  setup do
    @klass = Libvirt::Collection::DomainCollection
    @instance = @klass.new(Libvirt::Connection.connect("test:///default"))
  end

  should "provide a list of active domains" do
    active = @instance.active
    assert active.is_a?(Array)
    assert_equal 1, active.length
    assert active.all? { |a| a.is_a?(Libvirt::Domain) }
  end

  should "provide a list of inactive domains" do
    inactive = @instance.inactive
    assert inactive.is_a?(Array)
    # TODO: Define inactive domains and test they're here?
  end

  should "provide a list of all domains" do
    assert_equal (@instance.active + @instance.inactive), @instance.all
  end

  should "provide a length method" do
    assert_equal @instance.all.length, @instance.length
  end

  should "provide a first method" do
    assert_equal @instance.all.first, @instance.first
  end

  should "provide an each method" do
    assert @instance.respond_to?(:each)
  end
end
