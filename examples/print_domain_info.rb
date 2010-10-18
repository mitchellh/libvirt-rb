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

puts
h.domains.each do |d|
  puts "Domain: #{d.name}"
  puts "-----------"
  two_columns "ID:", d.id
  two_columns "UUID:", d.uuid
  two_columns "Memory:", humanize_bytes(d.memory)
  two_columns "Max Mem", humanize_bytes(d.max_memory)
  two_columns "State", d.state
  two_columns "Virtual CPUs:", d.virtual_cpus
  two_columns "CPU time used (nanosecs):", d.cpu_time_used
  two_columns "Active?:", d.active? ? 'yes': 'no'
  two_columns "Persistent?:", d.persistent? ? 'yes':'no'
  puts
end


