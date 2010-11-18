require 'test_helper'

Protest.describe("Domain spec") do
  setup do
    @klass = Libvirt::Spec::Domain
  end

  context "initialization" do
    setup do
      @instance= @klass.new
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
end
