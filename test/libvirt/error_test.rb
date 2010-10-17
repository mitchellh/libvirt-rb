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
      result = FFI::Libvirt.virConnectOpen("NSEpicFailure")
      assert result.null? # Sanity check on the failure

      # And now we verify the error is accessible
      error = @klass.last_error
      assert error
      assert_equal :system_error, error.code
    end
  end
end
