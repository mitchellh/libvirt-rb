## 0.2.1 (unreleased)

  - `FFI::Libvirt::MissingLibError` is raised if libvirt C library
    is not available.
  - `Libvirt::Spec::Network` added to parse network interfaces.
  - Interface device XML properly outputs `<source>` tag if `source_network`
    is specified.
  - Networks can be defined/created via the network collection.

## 0.2.0 (December 7, 2010)

  - Domain XML is now parsed into a `Libvirt::Spec::Domain` object,
    which can then be turned back into XML.

## 0.1.0 (November 16, 2010)

  - Initial release
