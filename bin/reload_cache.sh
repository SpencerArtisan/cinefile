#!/usr/bin/env ruby
$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
require 'cinefile'

datasource = CachedDataSource.new(Filter.new(DataSource.new, settings.max_cinemas))
puts 'clearing cache'
datasource.clear

puts 'loading cache'
Film.all datasource, settings.lookahead, settings.postcode

