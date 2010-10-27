class Protest::TestCase
  # Assert the value of an xpath expression is valid
  def assert_xpath(expected, xml, xpath, msg = nil)
    full_message = build_message(msg, '? at ? should be ?', xpath, xml, expected)
    assert_block full_message do
      value = Nokogiri::XML.parse(xml).at_xpath(xpath)
      value && value.text == expected
    end
  end

  # Assert an element exists
  def assert_element(xml, xpath, msg = nil)
    full_message = build_message(msg, 'element ? at ? not found', xpath, xml)
    assert_block full_message do
      element = Nokogiri::XML.parse(xml).at_xpath(xpath)
      !element.nil? && element.element?
    end
  end

  # Assert an element doesn't exist
  def assert_not_element(xml, xpath)
    assert_nil Nokogiri::XML.parse(xml).at_xpath(xpath)
  end

  # Assert a valid number of elements
  def assert_elements(expected_size, xml, xpath, msg = nil)
    assert_equal expected_size, Nokogiri::XML.parse(xml).xpath(xpath).size
  end
end
