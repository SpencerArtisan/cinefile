#!/usr/bin/env ruby
$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
require 'cinefile'

puts 'loading cache'
Cache.new.get_films settings.postcode, settings.lookahead, settings.max_cinemas

