require 'sinatra'
require 'film'

get '/films' do
  content_type :json
  Film.all.to_json
end
