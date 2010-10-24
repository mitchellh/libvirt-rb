module Libvirt
  module Assertions
    # Assert the value of an xpath expression is valid
    def assert_xpath(expected, xml, xpath, msg = nil)
      full_message = build_message(msg, '? at ? should be ?', xpath, xml, expected)
      assert_block full_message do
        value = Nokogiri::XML.parse(xml).at_xpath(xpath)
        return value == expected if expected.nil?
        return value.to_s == expected
      end
    end

    # Assert an element exists
    def assert_element(xml, xpath, msg = nil)
      full_message = build_message(msg, 'element ? at ? not found', xpath, xml)
      assert_block full_message do
        !Nokogiri::XML.parse(xml).at_xpath(xpath).nil? &&
          Nokogiri::XML.parse(xml).at_xpath(xpath).element?
      end
    end

    # Assert a valid number of elements
    def assert_elements(expected_size, xml, xpath, msg = nil)
      assert_equal expected_size, Nokogiri::XML.parse(xml).xpath(xpath).size
    end
  end
end
