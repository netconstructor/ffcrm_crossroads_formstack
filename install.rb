require 'rubygems'
require 'fileutils'

example_path = File.join(File.dirname(__FILE__),'config','formstack_settings.yml.example')
destination_path = File.expand_path(File.join(File.dirname(__FILE__),'..','..','..','config','formstack_settings.yml'))

FileUtils.copy example_path, destination_path

puts "=== Please edit '#{destination_path}' with your Formstack details."

