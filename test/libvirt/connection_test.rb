require "test_helper"

Protest.describe("connection") do
  setup do
    @klass = Libvirt::Connection
  end

  context "connecting" do
    should "connect given a pointer to a connection" do
      pointer = FFI::Libvirt.virConnectOpen("test:///default")
      result = @klass.new(pointer)
      assert_equal pointer, result.to_ptr
    end

    should "connect and return a connection" do
      result = nil
      assert_nothing_raised { result = @klass.new("test:///default") }
      assert result.is_a?(@klass)
    end

    should "connect to a readonly connection" do
      result = nil
      assert_nothing_raised { result = @klass.new("test:///default", :readonly => true) }
      assert result.is_a?(@klass)

      # Test readonly-ness
    end

    should "raise an exception if the connection fails" do
      assert_raise(Libvirt::Exception::LibvirtError) {
        @klass.new("thisshouldneverpass:)")
      }
    end
  end

  context "with a valid connection" do
    setup do
      @cxn = @klass.new("test:///default")
    end

    should "provide the library version" do
      # We rely on virsh to get the version of libvirt
      version = @cxn.lib_version
      actual = `virsh --version`.chomp.split(".").map { |s| s.to_i }
      assert_equal actual, version
    end

    should "provide the node" do
      result = @cxn.node
      assert result
      assert result.is_a?(Libvirt::Node)
      assert result.connection.eql?(@cxn)
    end

    should "provide the capabilities of the connection" do
      assert_nothing_raised { @cxn.capabilities }
    end

    should "provide the hostname of the connection" do
      assert_nothing_raised { @cxn.hostname }
    end

    should "provide the uri of the connection" do
      result = nil
      assert_nothing_raised { result = @cxn.uri }
      assert_equal "test:///default", result
    end

    should "provide the type of the connection" do
      result = nil
      assert_nothing_raised { result = @cxn.type }
      assert_equal "Test", result
    end

    should "provide the max virtual CPUs" do
      assert_equal 32, @cxn.max_virtual_cpus("test")
    end

    should "provide the hypervisor version of the connection" do
      result = nil
      assert_nothing_raised { result = @cxn.hypervisor_version }
      assert_equal [0,0,2], result
    end

    should "provide a list of domains" do
      result = nil
      assert_nothing_raised { result = @cxn.domains }
      assert result.is_a?(Libvirt::Collection::DomainCollection)
      assert @cxn.equal?(result.interface)
    end

    should "provide a list of interfaces" do
      result = nil
      assert_nothing_raised { result = @cxn.interfaces }
      assert result.is_a?(Libvirt::Collection::InterfaceCollection)
      assert @cxn.equal?(result.interface)
    end

    should "providea list of networks" do
      result = nil
      assert_nothing_raised { result = @cxn.networks }
      assert result.is_a?(Libvirt::Collection::NetworkCollection)
      assert @cxn.equal?(result.interface)
    end

    should "provide a list of NW filters" do
      result = nil
      assert_nothing_raised { result = @cxn.nwfilters }
      assert result.is_a?(Libvirt::Collection::NWFilterCollection)
      assert @cxn.equal?(result.interface)
    end

    should "provide a list of storage pools" do
      result = nil
      assert_nothing_raised { result = @cxn.storage_pools }
      assert result.is_a?(Libvirt::Collection::StoragePoolCollection)
      assert @cxn.equal?(result.interface)
    end

    should "check if encrypted" do
      assert !@cxn.encrypted?
    end

    should "check if secure" do
      assert @cxn.secure?
    end

    should "garbage collect the connection" do
      # TODO: Memprof this thing to figure out what is holding
      # references to a connection so the GC actually works.
    end
  end
end
