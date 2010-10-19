# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "libvirt/version"

Gem::Specification.new do |s|
  s.name        = "libvirt"
  s.version     = Libvirt::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mitchell Hashimoto"]
  s.email       = ["mitchell.hashimoto@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/libvirt"
  s.summary     = "A ruby client library providing the raw interface to libvirt via FFI."
  s.description = "A ruby client library providing the raw interface to libvirt via FFI."

  s.rubyforge_project = "libvirt"

  s.add_dependency "ffi", "~> 0.6.3"
  s.add_dependency "builder", "~> 2.1.2"
  s.add_dependency "nokogiri", "~> 1.4.3"

  s.add_development_dependency "protest", "~> 0.4.0"
  s.add_development_dependency "mocha", "~> 0.9.8"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
