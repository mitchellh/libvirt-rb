**WARNING: This gem is abandoned. It will not be worked on anymore. Please use the official libvirt libraries.**

# Libvirt Ruby Library

* Source: [http://github.com/mitchellh/libvirt-rb](http://github.com/mitchellh/libvirt-rb)
* IRC: `#vagrant` on Freenode
* Issues: [http://github.com/mitchellh/libvirt-rb/issues](http://github.com/mitchellh/libvirt-rb/issues)

A ruby client library providing the raw interface to libvirt via
FFI. The library is backwards compatible to libvirt 0.6.0. The
library consists of two namespaces:

* `Libvirt` - All objects under this namespace provide a very Ruby-like
  object oriented interface above the raw libvirt API. This is the recommended
  way of using libvirt with Ruby. These objects are mostly compatible with
  the FFI layer as well (you may pass in a `Connection` object in place of
  a `virConnectPtr` for example).
* `FFI::Libvirt` - A direct interface to the libvirt API using FFI. This is
  for the power players out there who need extremely customized functionality,
  with the tradeoff being that it is more complicated to use and you must manage
  your own pointers.

## Project Status

**Functional beta.** The project has been initially released with complete
FFI coverage and extensive coverage with the nicer Ruby objects. More
functionality will constantly be developed. If you'd like to see a specific
feature come first, please open an [issue](http://github.com/mitchellh/libvirt-rb/issues).

## Installation

This library will be a gem. First, you need to install libvirt, using
your OS's respective package manager. On OS X the recommended way is
using [homebrew](http://github.com/mxcl/homebrew):

    brew install libvirt

After installing libvirt, install the gem:

    gem install libvirt

If you'd like to try the bleeding edge version of libvirt-rb, we try
to keep master pretty stable and you're welcome to give it a shot. To
do this just clone out the repository and run this from the working
directory:

    rake install

## Usage

For detailed usage and examples, please view the documentation. But
a small example is shown below so you can get a feel for how the library
is meant to be used:

    require 'libvirt'

    conn = Libvirt.connect

    # Output some basic information
    puts "You are connected to: #{cxn.hypervisor}"
    puts "Hypervisor version: #{cxn.hypervisor_version}"
    puts "Libvirt version: #{cxn.lib_version}"

    # Output the names of all the domains
    conn.domains.each do |domain|
      puts "Domain: #{domain.name}"
    end

    # Start a domain and stop another
    conn.domains[0].start
    conn.domains[1].stop

    # Create a new domain (assuming `xml` is defined somewhere)
    # to an XML string
    new_domain = conn.domains.create(xml)
    puts "New domain created: #{new_domain.name}"

As I said earlier, please read the full usage page in the documentation
and also check out the examples in the `examples/` directory.

## Contributing

To contribute to the project, fork it and send me pull requests of any
changes made. For more information, see the [Hacker's Guide](http://github.com/mitchellh/libvirt-rb/wiki/Hacker's-Guide)
and the [Contributor's Guide](http://github.com/mitchellh/libvirt-rb/wiki/Contributor's-Guide).
