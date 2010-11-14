require "test_helper"

Protest.describe("storage volume collection") do
  setup do
    @klass = Libvirt::Collection::StorageVolumeCollection
    @instance = @klass.new(Libvirt.connect("test:///default").storage_pools.first)

    @single = @instance.create(<<-XML)
<volume>
  <name>test</name>
  <key>g9eba311-ea76-4e4a-ad7b-401fa81e38c8</key>
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

  context "finding" do
    should "find by any string" do
      assert @instance.find("test")
      assert @instance.find(@single.key)
      assert @instance.find(@single.path)
      assert !@instance.find("foo")
    end

    should "find by name" do
      assert @instance.find_by_name("test")
      assert_raises(Libvirt::Exception::LibvirtError) {
        @instance.find_by_name("slkjfdlksa")
      }
    end

    should "find by key" do
      assert @instance.find_by_key(@single.key)
      assert_raises(Libvirt::Exception::LibvirtError) {
        @instance.find_by_key("foo")
      }
    end

    should "find_by_path" do
      assert @instance.find_by_path(@single.path)
      assert_raises(Libvirt::Exception::LibvirtError) {
        @instance.find_by_path("foo")
      }
    end
  end

  should "be able to create a new volume" do
    result = @instance.create(<<-XML)
<volume>
  <name>test_vm_A.vdi</name>
  <key>f9eba311-ea76-4e4a-ad7b-401fa81e38c8</key>
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

    assert result
    assert @instance.all.include?(result)
  end

  should "provide a list of all volumes" do
    all = @instance.all
    assert all.is_a?(Array)
  end
end
