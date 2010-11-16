require "test_helper"

Protest.describe("storage pool") do
  setup do
    @klass = Libvirt::StoragePool

    @data = {
      :name => "default-pool",
      :uuid => "786f6276-656e-4074-8000-0a0027000000",
      :capacity => "107374182400"
    }

    @conn = Libvirt.connect("test:///default")
    @instance = @klass.new(FFI::Libvirt.virStoragePoolDefineXML(@conn, <<-XML, 0))
<pool type='dir'>
  <name>#{@data[:name]}</name>
  <uuid>#{@data[:uuid]}</uuid>
  <capacity>#{@data[:capacity]}</capacity>
  <allocation>0</allocation>
  <available>107374182400</available>
  <source>
  </source>
  <target>
    <path>/default-pool</path>
    <permissions>
      <mode>0700</mode>
      <owner>-1</owner>
      <group>-1</group>
    </permissions>
  </target>
</pool>
XML
  end

  should "be able to retrieve the connection" do
    result = @instance.connection
    assert result.is_a?(Libvirt::Connection)
  end

  should "provide the name" do
    result = @instance.name
    assert_equal @data[:name], result
  end

  should "provide the UUID" do
    result = @instance.uuid
    assert result
    assert_equal 36, result.length
  end

  should "provide the state" do
    assert_equal :running, @instance.state
    @instance.stop
    assert_equal :inactive, @instance.state
  end

  should "provide the capacity" do
    assert_equal @data[:capacity].to_i, @instance.capacity
  end

  should "provide the current allocation" do
    assert_equal 0, @instance.allocation
  end

  should "provide the available bytes remaining" do
    assert_equal 107374182400, @instance.available
  end

  should "dump the XML" do
    result = @instance.xml
    assert result
  end

  should "provide an active check" do
    @instance.start
    assert @instance.active?
  end

  should "provide a persistence check" do
    assert @instance.persistent?
    # TODO: Check state change. Not sure how to trigger this at the moment.
  end

  should "not raise an exception if instance is already active and start is called" do
    assert @instance.active?
    assert_nothing_raised { @instance.start }
  end

  should "be able to build storage pool" do
    @instance.stop
    assert @instance.build
  end

  context "deleting underlying resources" do
    setup do
      @instance.stop
    end

    should "be able to delete underlying resources" do
      assert @instance.delete
    end

    should "be able to specify type of delete" do
      assert @instance.delete(:zeroed)
    end
  end

  should "be able to be stopped" do
    assert @instance.active?
    @instance.stop
    assert !@instance.active?
  end

  should "be able to undefine a storage pool" do
    @instance.stop
    assert @conn.storage_pools.include?(@instance)
    @instance.undefine
    assert !@conn.storage_pools.include?(@instance)
  end

  should "provide a collection of volumes" do
    result = nil
    assert_nothing_raised { result = @instance.volumes }
    assert result.is_a?(Libvirt::Collection::StorageVolumeCollection)
  end

  should "provide a `to_ptr` method to get the pointer" do
    result = nil
    assert_nothing_raised { result = @instance.to_ptr }
    assert result.is_a?(FFI::Pointer)
    assert !result.null?
  end
end
