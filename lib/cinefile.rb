require 'sinatra'

get '/films' do
  Film.all.to_json
end
