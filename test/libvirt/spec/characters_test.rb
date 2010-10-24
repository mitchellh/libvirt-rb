require 'test_helper'

Protest.describe('Character device') do
  context('a console') do
    should "create an element 'console'" do
      character = Libvirt::Spec::Console.new('tty').to_xml
      assert_element character, '//console'
    end
  end

  context('a serial port') do
    should "create an element 'serial'" do
      character = Libvirt::Spec::Serial.new('tcp').to_xml
      assert_element character, '//serial'
    end

    should "include the protocol if exists" do
      serial = Libvirt::Spec::Serial.new('tcp')
      serial.protocol = {:type => 'raw'}
      xml = serial.to_xml

      assert_element xml, '//serial/protocol'
      assert_xpath 'raw', xml, '//serial/protocol/@type'
    end
  end

  context('a parallel port') do
    should "create an element 'parallel'" do
      character = Libvirt::Spec::Parallel.new('pty').to_xml
      assert_element character, '//parallel'
    end
  end

  context('a channel') do
    should "create an element 'channel'" do
      character = Libvirt::Spec::Channel.new('pty').to_xml
      assert_element character, '//channel'
    end
  end

  should "use the type parameter as attribute for the element" do
    channel = Libvirt::Spec::Channel.new('pty').to_xml
    assert_xpath 'pty', channel, '//channel/@type'
  end

  should "include the target if it's present" do
    channel = Libvirt::Spec::Channel.new('pty')
    channel.target = {:type => 'guestfwd', :address => '10.0.2.1', :port => '4600'}

    assert_element channel.to_xml, '//channel/target'
  end

  should "include the source if it's present" do
    channel = Libvirt::Spec::Channel.new('pty')
    channel.source = {:mode => 'bind', :path => '/tmp/guestfwd'}

    assert_element channel.to_xml, '//channel/source'
  end

  should "include all the sources if there are several" do
    serial = Libvirt::Spec::Serial.new('udp')
    serial.source = [
      {:mode => 'bind', :host => '0.0.0.0', :service => '2445'},
      {:mode => 'connect', :host => '0.0.0.0', :service => '2445'}
    ]
    assert_elements 2, serial.to_xml, '//serial/source'
  end
end
