require 'redis'
require 'uri'
require 'cinema'
require 'film_grouper'
require 'find_any_film'
require 'film_augmenter'
require 'film_filter'

class Cache
  FILM_KEY = "films"

  def initialize finder = FilmAugmenter.new(FilmGrouper.new(FilmFilter.new(FindAnyFilm.new)))
    @finder = finder
    puts "Using redis at '#{ENV["REDISTOGO_URL"]}'"
    uri = URI.parse(ENV["REDISTOGO_URL"])
    @redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  end

  def get_films postcode, days, max_cinemas
    films = cached_films
    if films.nil?
      films = @finder.get_films postcode, days, max_cinemas
      matches = UnreliableObjectDelegate.new(self, 60, 30).cached_films = films
    end
    def films.to_json
      {films: map {|film| film.to_hash}}.to_json
    end
    films
  ensure
    @redis.quit
  end

  def cached_films
    films = @redis.get FILM_KEY
    cached_films = Marshal::load(films) if films
    puts "Retrieved #{cached_films.length} films from cache" if films
    cached_films
  end

  def cached_films= films
    puts "Storing #{films.length} films in cache"
    @redis.set FILM_KEY, Marshal::dump(films)
  end

  def clear
    @redis.del FILM_KEY
  ensure
    @redis.quit
  end
end
