$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'cinefile'

run Sinatra::Application

