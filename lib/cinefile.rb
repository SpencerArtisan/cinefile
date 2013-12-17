require 'sinatra'
require 'cache'

set :root, File.join(File.dirname(__FILE__), '..')
set :lookahead, 21
set :postcode, 'WC1N'
set :max_cinemas, 30

get '/films' do
  content_type :json
  films = Cache.new.get_films settings.postcode, settings.lookahead, settings.max_cinemas
  films.to_json
end

get '/films/clear_cache' do
  Cache.new.clear
end

get '/' do
  erb :index
end
