require "rubygems"
require "bundler/setup"
require "libvirt"

#----------------------------------------------------------------------
# Helper methods for pretty printing
#----------------------------------------------------------------------
def two_columns(str1, str2)
  puts "#{str1}".ljust(40) + "#{str2}"
end

def humanize_bytes(bytes)
  if bytes < 1048576
    "#{bytes/1024} MB"
  else
    "#{bytes/1024/1024} GB"
  end
end

# Example connecting to a node and hypervisor:
#
# Example of valid URIs:
# vbox:///system (local virtualbox)
# qemu+tcp://10.0.0.1/system (remote qemu over TCP)
# qemu+ssh://10.0.0.1/system (remote qemu over SSH)
# qemu+unix:///system (local qemu over unix socket)
#
# If no URI is given, libvirt does its best to guess.
h = Libvirt::Connection.connect

puts "Hypervisor INFO"
puts "---------------"
two_columns "Hypervisor Type:", h.type
two_columns "Domains Created:", h.domains.size
# outputs XML
# puts h.capabilities
two_columns "Hostname:", h.hostname
two_columns "Connection URI:", h.uri
two_columns "Hypervisor Version:", h.hypervisor_version.join('.')
two_columns "Libvirt Version:", h.lib_version.join('.')
