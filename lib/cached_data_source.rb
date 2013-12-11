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
    cinemas = cached_cinemas post_code
    if cinemas.nil?
      cinemas = @data_source.find_cinemas post_code
      REDIS.set post_code, Marshal::dump(cinemas)
    end
    cinemas
  end

  def cached_cinemas post_code
    cinemas = REDIS.get post_code
    Marshal::load(cinemas) if cinemas
  end

  def clear
    REDIS.del REDIS.keys
  end
end
