# Libvirt Ruby Library

* Source: [http://github.com/mitchellh/libvirt-rb](http://github.com/mitchellh/libvirt-rb)
* IRC: `#vagrant` on Freenode
* Issues: [http://github.com/mitchellh/libvirt-rb/issues](http://github.com/mitchellh/libvirt-rb/issues)

A ruby client library providing the raw interface to libvirt via
FFI. This gem provides two things which can be used separately:

* `Ruby Objects` - For a more friendly experience, a nice set of
Ruby objects above the API which take away a lot of the pain are provided,
which is the recommended way of using libvirt with Ruby.
* `Raw API Access` - For the power-players out there, you can access
the `libvirt` API directly, with no fluff: Direct access to the C API
from Ruby.

## Project Status

**Unreleased and under development.** The project is still under heavy
initial development. If you are familiar and interested in any of the
following: Ruby, FFI, libvirt, virtualization and you want to get involved,
now is the best time!

What is done so far?

* The FFI function coverage is 100% complete. Some structs and enums
are missing, however.
* Basic [unit] test harness in place. Test early and often.
* Nice ruby layer starting, not much done in this area. A lot will
be done the coming days.

## Installation

This library will be a gem. First, you need to install libvirt, using
your OS's respective package manager. On OS X:

**Note: Libvirt installation on OS X is coming along, but is not
quite ready yet. Expect an update here soon.**

After installing libvirt, install the gem:

    gem install libvirt

## Usage

The usage is still up in the air since the gem is under development.
For now, here is some stuff that does work, but doesn't do anything
very useful!

    require 'libvirt'

    cxn = Libvirt::Connection.connect
    puts "You are connected to: #{cxn.hypervisor}"
    puts "Hypervisor version: #{cxn.hypervisor_version}"
    puts "Libvirt version: #{cxn.lib_version}"

Expect more exciting things soon! :)
