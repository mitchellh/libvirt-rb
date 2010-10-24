require 'test_helper'

Protest.describe('Spec::Encryptation') do
  should "use the required format as xml attribute" do
    enc = Libvirt::Spec::Encryptation.new('qcow')
    xml = Nokogiri::XML.parse(enc.to_xml)

    assert_equal 'qcow', xml.at_xpath('//encryptation')['format']
  end

  should "use the optional hash to set the secret attributes" do
    enc = Libvirt::Spec::Encryptation.new('qcow', {
      :type => 'passphrase',
      :uuid => 'c1f11a6d-8c5d-4a3e-ac7a-4e171c5e0d4a'
    })
    xml = Nokogiri::XML.parse(enc.to_xml)

    secret = xml.at_xpath('//encryptation/secret')
    assert_equal 'passphrase', secret['type']
    assert_equal 'c1f11a6d-8c5d-4a3e-ac7a-4e171c5e0d4a', secret['uuid']
  end

  should "not set the secret without attributes" do
    enc = Libvirt::Spec::Encryptation.new('qcow')
    xml = Nokogiri::XML.parse(enc.to_xml)

    assert_nil xml.at_xpath('//encryptation/secret')
  end
end
