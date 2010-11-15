require "rubygems"
require "bundler/setup"
require "libvirt"

# Warning: In the current version of the libvirt-rb library, the
# spec classes are not completely thought out and for now it is
# recommended that full XML strings are used.

spec = Libvirt::Spec::Domain.new

#
# Example of valid hypervisors
# :kvm
# :xen
# :test
#
spec.hypervisor = :test
spec.name = "My Test VM"
#
# :hvm (FullVirt in KVM anx Xen)
# :linux (Xen PV)
#
spec.os.type = :hvm
spec.memory = 123456 # KB

# Connect to the test hypervisor so we don't actually create a
# domain somewhere.
#
# Example of valid URIs:
# vbox:///system (local virtualbox)
# qemu+tcp://10.0.0.1/system (remote qemu over TCP)
# qemu+ssh://10.0.0.1/system (remote qemu over SSH)
# qemu+unix:///system (local qemu over unix socket)
# xen+tcp://10.0.0.1/ (remote Xen over TCP)
#
# If no URI is given, libvirt does its best to guess.
conn = Libvirt.connect("test:///default")

# This creates the domain on the hypervisor without starting it.
# The return value is the {Libvirt::Domain} object associated
# with it.
conn.domains.define(spec)

puts "Success! A test domain was created with the following XML:"
puts
puts spec.to_xml
