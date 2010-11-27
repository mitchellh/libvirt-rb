require 'test_helper'

Protest.describe("Domain clock spec") do
  setup do
    @klass = Libvirt::Spec::Domain::Clock
  end

  context "initialization and parsing XML" do
    should "parse the offset" do
      @instance = @klass.new("<clock offset='foo'/>")
      assert_equal :foo, @instance.offset
    end

    should "raise an exception if unsupported tags exist" do
      assert_raises(Libvirt::Exception::UnparseableSpec) {
        @klass.new("<clock offset='foo'><foo/></clock>")
      }
    end
  end
end
