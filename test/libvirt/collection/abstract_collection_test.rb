require "test_helper"

Protest.describe("abstract collection") do
  setup do
    @klass = Libvirt::Collection::AbstractCollection

    @connection = mock("connection")
    @instance = @klass.new(@connection)
  end

  should "have interface be available as an attribute" do
    assert_equal @connection, @instance.interface
  end
end
