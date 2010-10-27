require "test_helper"

Protest.describe("Disk device spec") do
  setup do
    @klass = Libvirt::Spec::Device::Disk
  end

  context "outputting XML" do
    setup do
      @instance = @klass.new(:file)
    end

    should "output given type for type in XML" do
      assert_xpath @instance.type.to_s, @instance.to_xml, "//disk/@type"
    end

    context "source" do
      should "not output source if not specified" do
        @instance.source = nil
        assert_not_element @instance.to_xml, "//disk/source"
      end

      should "output source attr as dev for block devices" do
        @instance.type = :block
        @instance.source = "foo"
        assert_xpath @instance.source, @instance.to_xml, "//disk/source/@dev"
      end

      should "output source attr as file for other devices" do
        @instance.type = :file
        @instance.source = "foo"
        assert_xpath @instance.source, @instance.to_xml, "//disk/source/@file"
      end
    end

    context "target" do
      should "not output target if not specified" do
        @instance.target_dev = nil
        assert_not_element @instance.to_xml, "//disk/target"
      end

      should "not output target if only bus is given" do
        @instance.target_dev = nil
        @instance.target_bus = "foo"
        assert_not_element @instance.to_xml, "//disk/target"
      end

      should "output specified dev on target" do
        @instance.target_dev = "foo"
        assert_xpath @instance.target_dev, @instance.to_xml, "//disk/target/@dev"
      end

      should "output specified bus on target" do
        @instance.target_dev = "foo"
        @instance.target_bus = "bar"
        assert_xpath @instance.target_bus, @instance.to_xml, "//disk/target/@bus"
      end
    end

    context "driver" do
      should "not output if no name is given" do
        @instance.driver = nil
        assert_not_element @instance.to_xml, "//disk/driver"
      end

      should "output with specified driver" do
        @instance.driver = "foo"
        assert_xpath @instance.driver, @instance.to_xml, "//disk/driver/@name"
      end

      should "output with specified type if given" do
        @instance.driver = "foo"
        @instance.driver_type = "bar"
        assert_xpath @instance.driver_type, @instance.to_xml, "//disk/driver/@type"
      end

      should "output with specified cache if given" do
        @instance.driver = "foo"
        @instance.driver_cache = "bar"
        assert_xpath @instance.driver_cache, @instance.to_xml, "//disk/driver/@cache"
      end
    end

    context "shareable" do
      should "not be sharable initially" do
        assert_not_element @instance.to_xml, "//disk/shareable"
      end

      should "be shareable if specified" do
        @instance.shareable = true
        assert_element @instance.to_xml, "//disk/shareable"
      end
    end

    context "serial" do
      should "not have serial if not specified" do
        @instance.serial = nil
        assert_not_element @instance.to_xml, "//disk/serial"
      end

      should "have serial if specified" do
        @instance.serial = "foobar"
        assert_xpath @instance.serial, @instance.to_xml, "//disk/serial"
      end
    end
  end
end
