module Libvirt
  module Assertions
    def assert_xpath(expected, xml, xpath, msg = nil)
      full_message = build_message(msg, '? at ? should be ?', xpath, xml, expected)
      assert_block full_message do
        value = Nokogiri::XML.parse(xml).at_xpath(xpath)
        return value == expected if expected.nil?
        return value.to_s == expected
      end
    end
  end
end
