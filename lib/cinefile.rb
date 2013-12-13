require 'sinatra'
require 'film'
require 'cached_data_source'
require 'find_any_film_data_source'
require 'filter'

set :root, File.join(File.dirname(__FILE__), '..')
set :lookahead, 14
set :postcode, 'WC1N'
set :max_cinemas, 50

helpers do
  def datasource
    CachedDataSource.new(Filter.new(FindAnyFilmDataSource.new, settings.max_cinemas))
  end
end

get '/films' do
  content_type :json
  films = Film.all datasource, settings.lookahead, settings.postcode
  films.to_json
end

get '/films/clear_cache' do
  datasource.clear
end

get '/' do
  erb :index
end
