require "test_helper"

Protest.describe("domain") do
  setup do
    @klass = Libvirt::Domain

    # TODO: Define our own domain so we have more control over what we're
    # testing.
    @instance = Libvirt::Connection.connect("test:///default").domains.all.first
  end

  should "provide the name of the domain" do
    assert_equal "test", @instance.name
  end

  should "provide the UUID of the domain" do
    result = nil
    assert_nothing_raised { result = @instance.uuid }
    assert_equal 36, result.length
  end

  should "provide the ID of the domain" do
    assert_equal 1, @instance.id
  end

  should "provide the state of the domain" do
    assert_equal :running, @instance.state
  end

  should "provide the maximum memory available on the domain" do
    assert_equal 8388608, @instance.max_memory
  end

  should "provide the memory allocated to the domain" do
    assert_equal 2097152, @instance.memory
  end

  should "provide the number of virtual CPUs attached to the domain" do
    assert_equal 2, @instance.virtual_cpus
  end

  should "provide the CPU time used in nanoseconds" do
    # This result is constantly changing so all we can really test is that
    # its properly returned
    result = nil
    assert_nothing_raised { result = @instance.cpu_time_used }
    assert result.is_a?(Integer)
  end

  should "provide an XML dump of the description of the domain" do
    result = nil
    assert_nothing_raised { result = @instance.xml }
    assert result.is_a?(String)
    assert !result.empty?
  end

  should "return result of active status" do
    assert @instance.active?
    @instance.destroy
    assert !@instance.active?
  end

  should "return result of persistent status" do
    # TODO: Test non-persistent domain
    assert @instance.persistent?
  end

  context "when creating" do
    should "return true if succeeds" do
      @instance.destroy
      assert @instance.create
    end

    should "not raise an error if the domain is already running" do
      assert @instance.active? # pre-requisite
      assert_nothing_raised { @instance.create }
    end
  end

  context "when destroying" do
    should "return true if succeeds" do
      assert @instance.destroy
    end

    should "not raise an error if the domain is already stopped" do
      @instance.destroy
      assert_nothing_raised { @instance.destroy }
    end
  end

  context "when suspending" do
    setup do
      @instance.create
    end

    should "return true if succeeds" do
      assert @instance.suspend
    end

    should "raise an error if the domain is already suspended" do
      @instance.suspend
      assert_raise(Libvirt::Exception::LibvirtError) {
        @instance.suspend
      }
    end

    should "raise an error if the domain is destroyed" do
      @instance.destroy
      assert_raise(Libvirt::Exception::LibvirtError) {
        @instance.suspend
      }
    end
  end

  context "when resuming" do
    should "return true if succeeds" do
      assert @instance.suspend
      assert @instance.resume
    end

    should "not raise an error if the domain is running" do
      assert @instance.active?
      assert @instance.resume
    end

    should "raise an error if the domain is destroyed" do
      @instance.destroy
      assert_raise(Libvirt::Exception::LibvirtError) {
        @instance.resume
      }
    end
  end
end
