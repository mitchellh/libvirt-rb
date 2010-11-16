# libvirt-rb User's Guide

## Overview

`libvirt-rb` is a Ruby library for [libvirt](http://libvirt.org), a library sponsored
by RedHat for talking to various hypervisors with a single API. `libvirt-rb` is backwards
compatible to libvirt 0.6.0 and consists of two namespaces for users to interact
with depending on their level of comfort with the libvirt API:

* `Libvirt` - All objects under this namespace provide a very Ruby-like
  object oriented interface above the raw libvirt API. This is the recommended
  way of using libvirt with Ruby. These objects are mostly compatible with
  the FFI layer as well (you may pass in a `Connection` object in place of
  a `virConnectPtr` for example).
* `FFI::Libvirt` - A direct interface to the libvirt API using FFI. This is
  for the power players out there who need extremely customized functionality,
  with the tradeoff being that it is more complicated to use and you must manage
  your own pointers.

## Installation

### Prerequisites

Before the library itself is installed, [libvirt](http://libvirt.org) must be
installed on the system. How to do this for various operating systems is shown
below.

#### Mac OS X

On Mac OS X, [homebrew](http://github.com/mxcl/homebrew) is the recommended
way of installing Mac OS X. There is currently not a MacPort for it.

    brew install libvirt

#### Linux

Most linux flavors have a libvirt installation in their respective package
managers. The libvirt library might be slightly out of date but if you
find you need the most up-to-date libvirt, its very easy to compile by
hand as well.

    apt-get install libvirt

#### Windows

While libvirt supposedly compiles on Windows, this is still a work in
progress on my part to verify the install and test the library. Hang
in there!

### Install libvirt-rb

`libvirt-rb` is packaged as a RubyGem, making the installation a one-step
process:

    gem install libvirt


## Basic Concepts and Usage

This section will cover the basic concepts of the higher level portion of
the libvirt ruby library (that is, it won't talk directly about the `FFI`
portion, which is mentioned in a later section). This is the portion of the
library that most people will use and is the recommended way of interacting
with libvirt from ruby.

This section _will not_ try cover how libvirt works or the various uses of
libvirt. Libvirt itself has many pages of documentation on this which you
should read to learn more about it.

### Establishing a Connection to Libvirt

The first step before anything can be done with libvirt is to establish
a connection to either a local or remote instance of libvirt (if remote,
you would be connecting to a `libvirtd` instance). Libvirt establishes
connections using a URI. Each line below is another example on how to
establish a connection:


    conn = Libvirt.connect
    conn = Libvirt.connect("test:///default")
    conn = Libvirt.connect("qemu+ssh://10.0.0.1/system")
    conn = Libvirt.connect("vbox:///system", :readonly => true)

This connection is the base object used to do most other things. Libvirt
has been made so that when you're done with the connection and it is
garbage collected, the underlying connection data is properly freed as
well. In fact, this is true for all objects in the libvirt library. If
you find a memory leak with the libvirt objects, it is a bug.

### Accessing Collections

Libvirt objects, especially the connection, exposes a variety of
_collection_ objects, such as domains, interfaces, networks, etc.
These collections are all exposed in a similar way, and this section
is meant to give a rough overview on how they work. Exact details
for each collection can be seen by reading their respective
documentation (such as {Libvirt::Collection::DomainCollection}).

### Using and Accessing Objects in Collections

All collections can be treated as `Array`-like objects. They are
`Enumerable` and provide additional methods as well. All collections
implement the `all` method to retrieve all of their collection.
Some collections can be drilled down further, such as domains, with
`inactive` and just `active`.

Examples of using a collection are shown below:

    # You can use a collection like an array:
    conn.domains.include?(other)

    # You can iterate over a collection:
    conn.domains.each do |domain|
      puts "Domain: #{domain.name}"
    end

    # You can drill down further on some collections:
    puts "Inactive domains: #{conn.domains.inactive.length}"

    # You can explicitly access all domains, though this is
    # the same as treating the whole collection as an array:
    puts "All domains: #{conn.domains.all.length}"

Understanding these collections are fundamental to using the library,
so play around with them and get comfortable.

### Creating and Defining Objects in Collections

Most collection objects support creation and definition. The difference
in libvirt is that defining will create a persistent object that survives
node reboots, but it will not start immediately. Creating, on the other
hand, creates and starts the object but it won't persist after reboots,
typically. Refer to the actual libvirt documentation for verification
on this.

Everything in libvirt is defined using XML. In the future, the libvirt-rb
library will probably provide Ruby object wrappers around these XML
structures but in the current version, you are expected to pass in the
XML as a string. An example is shown below:

    volume_xml = <<-XML
    <volume>
      <name>test</name>
      <key>g9eba311-ea76-4e4a-ad7b-401fa81e38c8</key>
      <source>
      </source>
      <capacity>8589934592</capacity>
      <allocation>33280</allocation>
      <target>
        <format type='raw'/>
        <permissions>
          <mode>00</mode>
          <owner>0</owner>
          <group>0</group>
        </permissions>
      </target>
    </volume>
    XML

    volume = conn.storage_pools.first.volumes.create(volume_xml)

**Note:** You can also retrieve the XML for an object using the `xml`
method which is available on most objects, such as {Libvirt::Domain#xml}.

### Using Libvirt Objects

Once you have retrieved a single libvirt object, such as {Libvirt::Connection Connection}
or {Libvirt::Domain Domain}, there are common ways to access information
and manipulate the object.

All objects have attributes which are accessed using simple method
calls, an example using a domain object below:

    puts domain.name
    puts domain.uuid
    puts domain.xml
    puts domain.state

Additionally, there are usually methods to control the state of an
object, and transition it to new states, such as starting or stopping
a domain:

    domain.start
    domain.stop
    domain.undefine

These methods return a boolean `true` or `false` depending on whether
they succeed or not.

### Error Handling

Libvirt itself provides a great error handling mechanism through
callbacks. By default, libvirt-rb will raise an {Libvirt::Exception::LibvirtError}
whenever an error occurs. That error contains a human readable
message and an error code, as well as a backtrace as to where the error
could have occurred. The exception simply wraps a {Libvirt::Error}
object.

If, instead of raising an exception for every error, you'd like
custom behavior, you can set a new callback which will be called
every time:

    Libvirt::Error.on_error do |error|
      # Do anything you want with `error`...
    end

You can also disable error callbacks alltogether by specifying no
block:

    Libvirt::Error.on_error

Most methods return `nil` on error. Some methods have no reasonable
way of representing an error (for example `nil` might just mean a
find failed), so doing nothing is not recommended.

## Advanced: Direct FFI Access

For advanced users out there, there is nearly 100% FFI coverage over
the libvirt API from the `FFI::Libvirt` namespace. This is a mostly
flat namespace for all the API methods, with classes for the various
structs. An example of using this API directly:

    c = FFI::Libvirt.virConnectOpen("test:///default")
    puts "Connected URI: #{FFI::Libvirt.virConnectGetURI(c)}"

### Creating libvirt-rb Objects with FFI Pointers

Many of the pointers returned by the FFI layer can be used to initialize
higher level objects, allowing a smooth transition between FFI and
libvirt-rb. An example of this is shown below:

    c = FFI::Libvirt.virConnectOpen("test:///default")

    # Use the pointer to create a Connection object, this is the
    # same as doing `Libvirt.connect("test:///default")`
    conn = Libvirt::Connection.new(c)

    # We are responsible for cleaning up the pointer. Since the Connection
    # object took ownership, this free simply decreases a reference count
    FFI::Libvirt.virConnectFree(c)

**Warning:** As you can see through the example above, you must remember
to _ALWAYS_ free your pointers after initializing a higher level object.
This is to ensure that memory is properly freed. Using the FFI API makes
it very easy to leak memory, so you have been warned.

### Using libvirt-rb Objects as Pointer Arguments

In addition to creating libvirt-rb objects, the libvirt-rb objects can
also be used as pointer arguments for the FFI API. This is because all
of the objects implement the `to_ptr` method. An example is shown below:

    c = Libvirt.connect("test:///default")
    puts "URI: #{FFI::Libvirt.virConnectGetURI(c)}"

**Warning:** If you store the pointer directly somewhere (assigning
the `to_ptr` value to a variable), do not forget to increase the
reference count by calling the respective API, since when the libvirt-rb
objects are garbage collected, they automatically free the pointer.
