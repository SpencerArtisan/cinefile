require 'redis'
require 'uri'
require 'cinema'

class CachedDataSource
  def initialize data_source
    @data_source = data_source
    puts "Using redis at '#{ENV["REDISTOGO_URL"]}'"
    uri = URI.parse(ENV["REDISTOGO_URL"])
    @redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  end

  def find_cinemas postcode
    cinemas = cached_cinemas postcode
    if cinemas.nil?
      cinemas = @data_source.find_cinemas postcode
      @redis.set cinema_key(postcode), Marshal::dump(cinemas)
    end
    cinemas
  end

  def cached_cinemas postcode
    cinemas = @redis.get cinema_key(postcode)
    Marshal::load(cinemas) if cinemas
  end

  def get_films cinema, day
    films = cached_films cinema, day
    if films.nil?
      films = @data_source.get_films cinema, day
      puts "Retrieved #{films.length} films for #{cinema.name} on day #{day}" if films
      @redis.set film_key(cinema, day), Marshal::dump(films)
    end
    films
  end

  def cached_films cinema, day
    films = @redis.get film_key(cinema, day)
    cached_films = Marshal::load(films) if films
    puts "Retrieved #{cached_films.length} films for #{cinema.name} on day #{day}" if films
    cached_films
  end

  def film_key cinema, day
    "key-#{cinema.name}-#{day}"
  end

  def cinema_key postcode
    "key-#{postcode}"
  end

  def clear
    @redis.del @redis.keys unless @redis.keys.empty?
  end
end
