require 'test_helper'

Protest.describe("Domain spec") do
  setup do
    @klass = Libvirt::Spec::Domain
  end

  context "initialization" do
    setup do
      @instance= @klass.new
    end

    should "not have any devices" do
      assert @instance.devices.empty?
    end
  end
end
