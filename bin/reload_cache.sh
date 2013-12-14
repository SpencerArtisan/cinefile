#!/usr/bin/env ruby
$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
require 'cinefile'

def datasource
  CachedDataSource.new(FilmAugmenter.new(Filter.new(FindAnyFilmDataSource.new, settings.max_cinemas), RottenTomatoes.new))
end

puts 'clearing cache'
datasource.clear

puts 'loading cache'
Film.all datasource, settings.lookahead, settings.postcode

