require 'sinatra'
require 'film'

get '/films' do
  content_type :json
  films = Film.all 1
  films.to_json
end

get '/' do
  erb :index
end
