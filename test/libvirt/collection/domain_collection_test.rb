require "test_helper"

Protest.describe("domain collection") do
  setup do
    @klass = Libvirt::Collection::DomainCollection
    @instance = @klass.new(Libvirt::Connection.new("test:///default"))
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

  context "a new domain" do
    setup do
      @spec = Libvirt::Spec::Domain.new
      @spec.hypervisor = :test
      @spec.name = "My Test VM"
      @spec.os.type = :hvm
      @spec.memory = 123456 # KB
    end

    context "defining a new domain" do
      should "define the new domain when the specification is valid" do
        result = nil
        assert_nothing_raised { result = @instance.define(@spec) }
        assert result.is_a?(Libvirt::Domain)
        assert !result.active?
        assert_equal @spec.name, result.name
      end

      should "define the new domain when the specification is a string" do
        result = nil
        assert_nothing_raised { result = @instance.define(@spec.to_xml) }
        assert result.is_a?(Libvirt::Domain)
        assert !result.active?
        assert_equal @spec.name, result.name
      end

      should "raise an error when the specification is not valid" do
        @spec.hypervisor = nil
        assert_raise(Libvirt::Exception::LibvirtError) {
          @instance.define(@spec)
        }
      end
    end

    context "creating a new domain" do
      should "create the new domain with the specification" do
        result = nil
        assert_nothing_raised { result = @instance.create(@spec) }
        assert result.is_a?(Libvirt::Domain)
        assert result.active?
        assert_equal @spec.name, result.name
      end

      should "create a new domain with a string specification" do
        result = nil
        assert_nothing_raised { result = @instance.create(@spec.to_xml) }
        assert result.is_a?(Libvirt::Domain)
        assert result.active?
        assert_equal @spec.name, result.name
      end
    end
  end
end
