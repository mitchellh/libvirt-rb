require 'test_helper'

Protest.describe('Spec::Encryptation') do
  should "use the required format as xml attribute" do
    enc = Libvirt::Spec::Encryptation.new('qcow').to_xml
    assert_xpath 'qcow', enc, '//encryptation/@format'
  end

  should "use the optional hash to set the secret attributes" do
    enc = Libvirt::Spec::Encryptation.new('qcow', {
      :type => 'passphrase',
      :uuid => 'c1f11a6d-8c5d-4a3e-ac7a-4e171c5e0d4a'
    }).to_xml

    assert_xpath 'passphrase', enc, '//encryptation/secret/@type'
    assert_xpath 'c1f11a6d-8c5d-4a3e-ac7a-4e171c5e0d4a', enc, '//encryptation/secret/@uuid'
  end

  should "not set the secret without attributes" do
    enc = Libvirt::Spec::Encryptation.new('qcow').to_xml
    assert_xpath nil, enc, '//encryptation/secret'
  end
end
