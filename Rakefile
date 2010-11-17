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

# Testing against specific rubies or all of them. This uses RVM
# and expects these rubies to be installed already.
rubies = ["1.9.2", "1.8.7", "jruby", "rbx"]
rubies.each do |ruby|
  desc "Run the test suite against: #{ruby}"
  task "test_#{ruby.gsub('.', '_')}" do
    puts "Running test suite against: #{ruby}"
    exec("rvm #{ruby} rake")
  end
end

desc "Run the test suite against all rubies: #{rubies.join(", ")}"
task :test_all do
  rubies.each do |ruby|
    puts "Running test suite against: #{ruby}"
    pid = fork
    exec "rvm #{ruby} rake" if !pid
    Process.wait(pid) if pid
  end
end

begin
  # Documentation task
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
end
