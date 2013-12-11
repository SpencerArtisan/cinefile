require 'redis'
require 'uri'
require 'venue'

puts "Using redis at '#{ENV["REDISTOGO_URL"]}'"
uri = URI.parse(ENV["REDISTOGO_URL"])
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

class CachedDataSource
  def initialize data_source
    @data_source = data_source
  end

  def find_cinemas post_code
    cinemas = cached_cinemas post_code
    if cinemas.nil?
      cinemas = @data_source.find_cinemas post_code
      REDIS.set cinema_key(post_code), Marshal::dump(cinemas)
    end
    cinemas
  end

  def cached_cinemas post_code
    cinemas = REDIS.get cinema_key(post_code)
    Marshal::load(cinemas) if cinemas
  end

  def get_films cinema, day
    films = cached_films cinema, day
    if films.nil?
      films = @data_source.get_films cinema, day
      REDIS.set film_key(cinema, day), Marshal::dump(films)
    end
    films
  end

  def cached_films cinema, day
    films = REDIS.get film_key(cinema, day)
    Marshal::load(films) if films
  end

  def film_key cinema, day
    "key-#{cinema.name}-#{day}"
  end

  def cinema_key post_code
    "key-#{post_code}"
  end

  def clear
    REDIS.del REDIS.keys unless REDIS.keys.empty?
  end
end
