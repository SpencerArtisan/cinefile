require 'sinatra'
require 'film'
require 'cache'
require 'find_any_film_data_source'
require 'film_augmenter'
require 'filter'
require 'rotten_tomatoes'
require 'film_grouper'

set :root, File.join(File.dirname(__FILE__), '..')
set :lookahead, 14
set :postcode, 'WC1N'
set :max_cinemas, 30

helpers do
  def cache
    Cache.new(FilmAugmenter.new(FilmGrouper.new(Filter.new(FindAnyFilmDataSource.new, settings.max_cinemas)), RottenTomatoes.new))
  end
end

get '/films' do
  content_type :json
  films = cache.get_films settings.postcode, settings.lookahead
  films.to_json
end

get '/films/clear_cache' do
  cache.clear
end

get '/' do
  erb :index
end
