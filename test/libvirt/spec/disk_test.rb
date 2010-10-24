require 'test_helper'

Protest.describe("Spec::Disk") do
  setup do
    @disk = Libvirt::Spec::Disk.new('file')
  end

  should "not be shareable by default" do
    assert_not_element @disk.to_xml, '//disk/shareable'
  end

  should "be shareable if the parameter is true" do
    disk = Libvirt::Spec::Disk.new('file', true).to_xml
    assert_element disk, '//disk/shareable'
  end

  should "use the type as attribute for the xml element" do
    assert_xpath 'file', @disk.to_xml, '//disk/@type'
  end

  should "include the driver if exists" do
    @disk.driver = {:name => 'tap', :type => 'aio', :cache => 'default'}
    assert_xpath 'tap', @disk.to_xml, '//disk/driver/@name'
  end

  should "include the source if exists" do
    @disk.source = {:file => '/var/lib/xen/images/fv0'}
    assert_xpath '/var/lib/xen/images/fv0', @disk.to_xml, '//disk/source/@file'
  end

  should "include the target if exists" do
    @disk.target = {:dev => 'hda'}
    assert_xpath 'hda', @disk.to_xml, '//disk/target/@dev'
  end

  should "include the encryptation if exists" do
    @disk.encryptation = Libvirt::Spec::Encryptation.new('qcow')
    assert_xpath 'qcow', @disk.to_xml, '//disk/encryptation/@type'
  end

  should "include the serial number if exist" do
    @disk.serial = 'WD-WMAP9A966149'
    assert_xpath 'WD-WMAP9A966149', @disk.to_xml, '//disk/serial'
  end
end
