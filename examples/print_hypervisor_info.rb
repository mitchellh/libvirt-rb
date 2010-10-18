require 'rubygems'
require 'libvirt'

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

#
# Connect to a KVM in 10.0.0.1, using TCP
# other valid URIs:
# qemu+tcp://10.0.0.1/system
# qemu+ssh://10.0.0.1/system
# qemu+unix:///system (local only)
h = Libvirt::Connection.connect("qemu+tcp://10.0.0.1/system")

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
