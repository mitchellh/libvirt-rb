require "test_helper"

Protest.describe("node") do
  setup do
    @klass = Libvirt::Node

    @connection = Libvirt.connect("test:///default")
    @instance = @connection.node
  end

  should "provide access to the connection" do
    assert_equal @connection, @instance.connection
  end

  # Note: This class is extremely hard to test since the results actually
  # change computer to computer. Mocking/stubbing probably required.
end
