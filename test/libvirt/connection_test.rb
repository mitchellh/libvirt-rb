require "test_helper"

Protest.describe("connection") do
  setup do
    @klass = Libvirt::Connection
  end

  context "connecting" do
    should "connect and return a connection" do
      result = nil
      assert_nothing_raised { result = @klass.connect }
      assert result.is_a?(@klass)
    end

    should "raise an exception if the connection fails" do
      assert_raise(Libvirt::Exception::ConnectionFailed) {
        @klass.connect("thisshouldneverpass:)")
      }
    end
  end

  context "with a valid connection" do
    setup do
      @cxn = @klass.connect
    end

    should "provide the library version" do
      # Yes, this will fail when the library version changes, but
      # this will help catch when packages are updated and so on.
      assert_equal [0,8,4], @cxn.lib_version
    end

    should "provide the hostname of the connection" do
      assert_nothing_raised { @cxn.hostname }
    end

    should "provide the capabilities of the connection" do
      assert_nothing_raised { @cxn.capabilities }
    end
  end
end
