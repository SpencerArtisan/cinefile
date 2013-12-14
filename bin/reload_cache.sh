#!/usr/bin/env ruby
$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
require 'cinefile'

def cache
  Cache.new(FilmAugmenter.new(FilmGrouper.new(Filter.new(FindAnyFilmDataSource.new, settings.max_cinemas)), RottenTomatoes.new))
end

puts 'clearing cache'
cache.clear

puts 'loading cache'
cache.get_films settings.postcode, settings.lookahead

