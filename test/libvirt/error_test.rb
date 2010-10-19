require "test_helper"

Protest.describe("error") do
  setup do
    @klass = Libvirt::Error
  end

  context "getting the last error" do
    setup do
      # Reset the error manually so we're clear.
      FFI::Libvirt.virResetLastError
    end

    should "be fine if there is no last error" do
      result = nil
      assert_nothing_raised { result = @klass.last_error }
      assert result.nil?
    end

    should "report the last error" do
      begin
        FFI::Libvirt.virConnectOpen("NSEpicFailure")
      rescue Libvirt::Exception::LibvirtError; end

      # And now we verify the error is accessible
      error = @klass.last_error
      assert error
    end
  end

  context "setting an error handling callback" do
    teardown do
      # Reset the error handler to nil
      @klass.on_error
    end

    should "call the callback when an error occurs" do
      called = false
      @klass.on_error do |error|
        called = true
      end

      FFI::Libvirt.virConnectOpen("foo") rescue nil
      assert called
    end
  end

  context "with an error instance" do
    setup do
      # Get an error instance...
      @error = nil
      begin
        FFI::Libvirt.virConnectOpen("FailHard")
      rescue Libvirt::Exception::LibvirtError => e
        @error = e.error
      end
    end

    should "allow access to the raw struct" do
      assert @error.interface.is_a?(FFI::Libvirt::Error)
    end

    should "allow access to the error code" do
      assert_equal :system_error, @error.code
    end

    should "allow access to the error domain" do
      assert_equal :remote, @error.domain
    end

    should "allow access to the error message" do
      assert @error.message
    end
  end
end
