require 'redis'
require 'uri'
require 'cinema'

class Cache
  FILM_KEY = "films"

  def initialize finder = FilmAugmenter.new(FilmGrouper.new(FilmFilter.new(FindAnyFilmDataSource.new, settings.max_cinemas)), RottenTomatoes.new)
    @finder = finder
    puts "Using redis at '#{ENV["REDISTOGO_URL"]}'"
    uri = URI.parse(ENV["REDISTOGO_URL"])
    @redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  end

  def get_films postcode, days
    films = cached_films
    if films.nil?
      films = @finder.get_films postcode, days
      self.cached_films = films
    end
    def films.to_json
      {films: map {|film| film.to_hash}}.to_json
    end
    films
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
  end
end
