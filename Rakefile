require 'rubygems'
require 'bundler'
require 'bundler/setup'
Bundler::GemHelper.install_tasks

task :default => :test

desc "Run the test suite."
task :test do
  $:.unshift File.expand_path("../test", __FILE__)
  files = ENV["TEST"] ? [ENV["TEST"]] : Dir["test/**/*_test.rb"]
  files.each { |f| load f }
end
