require "rubygems"
require "bundler/setup"
require "libvirt"

# NOTE: The domain creation interface is currently under heavy
# construction and will likely change. This example file showcases
# how it works currently.

spec = Libvirt::DomainSpecification.new
spec.hypervisor = :test
spec.name = "My Test VM"
spec.os.type = :hvm
spec.memory = 123456 # KB

# Connect to the test hypervisor so we don't actually create a
# domain somewhere.
conn = Libvirt::Connection.connect("test:///default")

# One day there will be a nicer way to do this, for now while its
# being worked out, this has to be done manually
FFI::Libvirt.virDomainDefineXML(conn.pointer, spec.to_xml)

puts "Success! A test domain was created with the following XML:"
puts
puts spec.to_xml
