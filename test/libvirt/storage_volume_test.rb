require "test_helper"

Protest.describe("storage volume") do
  setup do
    @klass = Libvirt::StorageVolume

    @data = {
      :name => "test_vm_A.vdi",
      :key => "f9eba311-ea76-4e4a-ad7b-401fa81e38c8"
    }

    @connection = Libvirt.connect("test:///default")
    @instance = @connection.storage_pools.first.volumes.create(<<-XML)
<volume>
  <name>#{@data[:name]}</name>
  <key>#{@data[:key]}</key>
  <source>
  </source>
  <capacity>8589934592</capacity>
  <allocation>33280</allocation>
  <target>
    <format type='raw'/>
    <permissions>
      <mode>00</mode>
      <owner>0</owner>
      <group>0</group>
    </permissions>
  </target>
</volume>
XML
  end

  should "be able to retrieve the key" do
    assert @instance.uuid
  end

  should "be able to retrieve the name" do
    assert_equal @data[:name], @instance.name
  end

  should "be able to retrieve the path" do
    assert_equal "/default-pool/test_vm_A.vdi", @instance.path
  end

  should "be able to retrieve the type of this volume" do
    assert_equal :file, @instance.type
  end

  should "be able to retrieve the capacity" do
    assert_equal 8589934592, @instance.capacity
  end

  should "be able to retrieve the allocation" do
    assert_equal 33280, @instance.allocation
  end
end
