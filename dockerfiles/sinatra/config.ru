# Rackup File
require 'rubygems'
require 'bundler/setup'
require File.expand_path '../hello.rb', __FILE__
run Sinatra::Application