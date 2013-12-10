require 'sinatra'
require 'film'

puts "********"
puts settings.root
set :root, File.join(File.dirname(__FILE__), '..')
puts settings.root

get '/films' do
  content_type :json
  films = Film.all 1
  films.to_json
end

get '/' do
  erb :index
end
