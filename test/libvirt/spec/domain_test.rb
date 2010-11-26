require 'test_helper'

Protest.describe("Domain spec") do
  setup do
    @klass = Libvirt::Spec::Domain
  end

  context "initialization" do
    setup do
      @instance = @klass.new
    end

    should "initialize an OS booting object" do
      assert @instance.os.is_a?(Libvirt::Spec::Domain::OSBooting)
    end

    should "not have any devices" do
      assert @instance.devices.empty?
    end

    should "initialize a memtune object" do
      assert @instance.memtune.is_a?(Libvirt::Spec::Domain::Memtune)
    end
  end

  context "initialization with spec parsing" do
    should "raise an exception if an invalid tag is found" do
      assert_raises(Libvirt::Exception::UnparseableSpec) {
        @klass.new(<<-XML)
<domain><foo></foo></domain>
XML
      }
    end

    should "parse the hypervisor" do
      @instance = @klass.new(<<-XML)
<domain type='vbox'></domain>
XML

      assert_equal :vbox, @instance.hypervisor
    end

    should "parse the name" do
      @instance = @klass.new(<<-XML)
<domain type='vbox'>
  <name>test_vm_A</name>
</domain>
XML

      assert_equal "test_vm_A", @instance.name
    end

    should "parse the UUID" do
      @instance = @klass.new(<<-XML)
<domain>
  <uuid>foo</uuid>
</domain>
XML

      assert_equal "foo", @instance.uuid
    end

    should "parse the memory" do
      @instance = @klass.new(<<-XML)
<domain>
  <memory>123456</memory>
</domain>
XML

      assert_equal "123456", @instance.memory
    end

    should "parse the UUID" do
      @instance = @klass.new(<<-XML)
<domain>
  <currentMemory>1234</currentMemory>
</domain>
XML

      assert_equal "1234", @instance.current_memory
    end

    should "parse the VCPU count" do
      @instance = @klass.new(<<-XML)
<domain>
  <vcpu>4</vcpu>
</domain>
XML

      assert_equal "4", @instance.vcpu
    end

    should "parse on_poweroff" do
      @instance = @klass.new(<<-XML)
<domain>
  <on_poweroff>foo</on_poweroff>
</domain>
XML

      assert_equal :foo, @instance.on_poweroff
    end

    should "parse on_reboot" do
      @instance = @klass.new(<<-XML)
<domain>
  <on_reboot>foo</on_reboot>
</domain>
XML

      assert_equal :foo, @instance.on_reboot
    end

    should "parse on_crash" do
      @instance = @klass.new(<<-XML)
<domain>
  <on_crash>foo</on_crash>
</domain>
XML

      assert_equal :foo, @instance.on_crash
    end
  end
end
