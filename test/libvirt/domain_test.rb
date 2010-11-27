require "test_helper"

Protest.describe("domain") do
  setup do
    @klass = Libvirt::Domain

    @spec = Libvirt::Spec::Domain.new
    @spec.hypervisor = :test
    @spec.name = "libvirt-rb-test"
    @spec.os.type = :hvm
    @spec.memory = 123456 # KB

    @conn = Libvirt.connect("test:///default")
    @instance = @conn.domains.define(@spec)
  end

  should "provide the name of the domain" do
    assert_equal "libvirt-rb-test", @instance.name
  end

  should "provide the UUID of the domain" do
    result = nil
    assert_nothing_raised { result = @instance.uuid }
    assert_equal 36, result.length
  end

  should "provide the ID of the domain" do
    assert_equal 4294967295, @instance.id
  end

  should "provide the OS type of the domain" do
    assert_equal "linux", @instance.os_type
  end

  should "provide the state of the domain" do
    assert_equal :shutoff, @instance.state
  end

  context "maximum memory" do
    should "be retrievable" do
      assert_equal 123456, @instance.max_memory
    end

    should "be settable" do
      @instance.max_memory = 234567
      assert_equal 234567, @instance.max_memory
    end
  end

  context "memory" do
    should "be retrievable" do
      assert_equal 123456, @instance.memory
    end

    should "be settable" do
      @instance.memory = 7000
      assert_equal 7000, @instance.memory
    end
  end

  context "virtual CPUs" do
    should "be retrievable" do
      assert_equal 1, @instance.virtual_cpus
    end

    should "be able to retrieve maximum" do
      @instance.start
      assert_equal 1, @instance.max_virtual_cpus
    end

    should "be settable" do
      @instance.start
      @instance.virtual_cpus = 1
      assert_equal 1, @instance.virtual_cpus
    end
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

  should "provide the spec object for the domain" do
    result = nil
    assert_nothing_raised { result = @instance.spec }
    assert result.is_a?(Libvirt::Spec::Domain)
  end

  should "return result of active status" do
    @instance.start
    assert @instance.active?
    @instance.destroy
    assert !@instance.active?
  end

  should "return result of persistent status" do
    # Instance domain is defined so should be persistent:
    assert @instance.persistent?

    # Create a new domain, shouldn't be persistent
    @spec.name = "another"
    other = @conn.domains.create(@spec)
    assert !other.persistent?
  end

  context "autostart" do
    should "check status" do
      assert !@instance.autostart?
    end

    should "set status" do
      @instance.autostart = true
      assert @instance.autostart?
    end
  end

  context "when creating" do
    should "return true if succeeds" do
      @instance.destroy
      assert !@instance.active?
      assert @instance.create
      assert @instance.active?
    end

    should "not raise an error if the domain is already running" do
      @instance.start
      assert @instance.active? # pre-requisite
      assert_nothing_raised { @instance.create }
    end

    should "also respond to `start`" do
      assert !@instance.active?
      assert @instance.start
      assert @instance.active?
    end
  end

  context "when destroying" do
    should "return true if succeeds" do
      assert @instance.destroy
      assert !@instance.active?
    end

    should "not raise an error if the domain is already stopped" do
      @instance.destroy
      assert_nothing_raised { @instance.destroy }
    end

    should "also respond to `stop`" do
      assert @instance.stop
      assert !@instance.active?
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
    setup do
      @instance.create
    end

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

  should "be able to reboot" do
    assert_nothing_raised { @instance.reboot }
  end

  should "be able to shutdown" do
    @instance.start
    assert_nothing_raised { @instance.shutdown }
  end

  should "be able to undefine a domain" do
    @instance.destroy
    assert @conn.domains.include?(@instance)
    @instance.undefine
    assert !@conn.domains.include?(@instance)
  end
end
