require "test_helper"

Protest.describe("storage pool") do
  setup do
    @klass = Libvirt::StoragePool

    @data = {
      :name => "default-pool",
      :uuid => "786f6276-656e-4074-8000-0a0027000000"
    }

    @conn = Libvirt.connect("test:///default")
    @instance = @klass.new(FFI::Libvirt.virStoragePoolDefineXML(@conn, <<-XML, 0))
<pool type='dir'>
  <name>#{@data[:name]}</name>
  <uuid>#{@data[:uuid]}</uuid>
  <capacity>107374182400</capacity>
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

  should "provide the name" do
    result = @instance.name
    assert_equal @data[:name], result
  end

  should "provide the UUID" do
    result = @instance.uuid
    assert result
    assert_equal 36, result.length
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

  should "provide a `to_ptr` method to get the pointer" do
    result = nil
    assert_nothing_raised { result = @instance.to_ptr }
    assert result.is_a?(FFI::Pointer)
    assert !result.null?
  end
end
