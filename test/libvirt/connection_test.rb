require "test_helper"

Protest.describe("connection") do
  setup do
    @klass = Libvirt::Connection
  end

  context "connecting" do
    should "connect and return a connection" do
      result = nil
      assert_nothing_raised { result = @klass.new("test:///default") }
      assert result.is_a?(@klass)
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

    should "provide the hypervisor version of the connection" do
      result = nil
      assert_nothing_raised { result = @cxn.hypervisor_version }
      assert_equal [0,0,2], result
    end

    should "provide a list of domains" do
      result = nil
      assert_nothing_raised { result = @cxn.domains }
      assert result.is_a?(Libvirt::Collection::DomainCollection)
      assert @cxn.equal?(result.connection)
    end

    should "provide a list of interfaces" do
      result = nil
      assert_nothing_raised { result = @cxn.interfaces }
      assert result.is_a?(Libvirt::Collection::InterfaceCollection)
      assert @cxn.equal?(result.connection)
    end

    should "providea list of networks" do
      result = nil
      assert_nothing_raised { result = @cxn.networks }
      assert result.is_a?(Libvirt::Collection::NetworkCollection)
      assert @cxn.equal?(result.connection)
    end
  end
end
