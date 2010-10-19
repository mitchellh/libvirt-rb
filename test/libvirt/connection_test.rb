require "test_helper"

Protest.describe("connection") do
  setup do
    @klass = Libvirt::Connection
  end

  context "connecting" do
    should "connect and return a connection" do
      result = nil
      assert_nothing_raised { result = @klass.connect("test:///default") }
      assert result.is_a?(@klass)
    end

    should "raise an exception if the connection fails" do
      assert_raise(Libvirt::Exception::LibvirtError) {
        @klass.connect("thisshouldneverpass:)")
      }
    end
  end

  context "with a valid connection" do
    setup do
      @cxn = @klass.connect("test:///default")
    end

    should "provide the library version" do
      # Yes, this will fail when the library version changes, but
      # this will help catch when packages are updated and so on.
      assert_equal [0,8,4], @cxn.lib_version
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
      assert result.is_a?(Array)
      assert_equal 1, result.length
      assert result.first.is_a?(Libvirt::Domain)
    end
  end
end
