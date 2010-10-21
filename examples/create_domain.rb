require "rubygems"
require "bundler/setup"
require "libvirt"

# NOTE: The domain creation interface is currently under heavy
# construction and will likely change. This example file showcases
# how it works currently.

spec = Libvirt::Spec::Domain.new
spec.hypervisor = :test
spec.name = "My Test VM"
spec.os.type = :hvm
spec.memory = 123456 # KB

# Connect to the test hypervisor so we don't actually create a
# domain somewhere.
conn = Libvirt::Connection.connect("test:///default")

# This creates the domain on the hypervisor without starting it.
# The return value is the {Libvirt::Domain} object associated
# with it.
conn.define_domain(spec)

puts "Success! A test domain was created with the following XML:"
puts
puts spec.to_xml
