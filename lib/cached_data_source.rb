require 'environment'
require 'redis'
require 'uri'
require 'venue'

uri = URI.parse(ENV["REDISTOGO_URL"])
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

class CachedDataSource
  def initialize data_source
    @data_source = data_source
  end

  def find_cinemas post_code
    cinemas = cached_cinemas
    puts "REDIS CINEMAS: #{cinemas}, #{cinemas.class}"
    if cinemas.nil?
      cinemas = @data_source.find_cinemas post_code
      REDIS.set 'cinemas', Marshal::dump(cinemas)
    end
    cinemas
  end

  def cached_cinemas
    cinemas = REDIS.get 'cinemas'
    Marshal::load(cinemas) if cinemas
  end

  def clear
    REDIS.del 'cinemas'
  end
end
