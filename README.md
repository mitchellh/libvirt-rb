# `libvirt` Ruby Library

A ruby client library providing the raw interface to libvirt via
FFI. This gem provides two things which can be used separately:
a nice Ruby object oriented layer above the libvirt API along with
a pure FFI layer on top of the libvirt API. If you're already familiar
with libvirt and want advanced access directly to the C layer, you
can do that. Otherwise, the object oriented layer is recommend, since
this provides some nice abstractions above the entire API, while still
providing you direct access to the FFI layer if necessary.

