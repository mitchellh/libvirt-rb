require "test_helper"

Protest.describe("domain") do
  setup do
    @klass = Libvirt::Domain

    # TODO: Define our own domain so we have more control over what we're
    # testing.
    @instance = Libvirt::Connection.connect("test:///default").domains.first
  end

  should "provide the state of the domain" do
    assert_equal :running, @instance.state
  end

  should "provide the maximum memory available on the domain" do
    assert_equal 8388608, @instance.max_memory
  end

  should "provide the memory allocated to the domain" do
    assert_equal 2097152, @instance.memory
  end

  should "provide the number of virtual CPUs attached to the domain" do
    assert_equal 2, @instance.virtual_cpus
  end

  should "provide the CPU time used in nanoseconds" do
    # This result is constantly changing so all we can really test is that
    # its properly returned
    result = nil
    assert_nothing_raised { result = @instance.cpu_time_used }
    assert result.is_a?(Integer)
  end
end
