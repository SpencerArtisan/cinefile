require 'sinatra'
require 'film'

get '/films' do
  content_type :json
  films = Film.all 2
  puts films.to_json
  films.to_json
end
