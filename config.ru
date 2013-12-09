$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'cinefile'
require 'sprockets'

map "/assets" do
  environment = Sprockets::Environment.new
  environment.append_path "assets/javascripts"
  environment.append_path "views"
  run environment
end

run Sinatra::Application

