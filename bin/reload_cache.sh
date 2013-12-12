#!/usr/bin/env ruby
$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
require 'film'
require 'cached_data_source'
require 'filter'


datasource = CachedDataSource.new(Filter.new(DataSource.new))
puts 'clearing cache'
datasource.clear
puts 'loading cache'
films = Film.all datasource, 7

