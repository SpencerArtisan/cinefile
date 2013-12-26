require 'sinatra'
require 'cache'

require 'capybara'

set :root, File.join(File.dirname(__FILE__), '..')
set :postcode, 'WC1N'
#set :lookahead, 21
#set :max_cinemas, 35
set :lookahead, 1
set :max_cinemas, 1

class FindAnyFilm
  def read_films cinema, day
    File.read('find_any_film_sample.json')
  end
  def read_cinemas postcode
    File.read('cinemas_sample.html')
  end
end
class RottenMovie
  def self.find title
    double links: double(alternate: 'a link'), ratings: double(critics_score: 92), release_dates: double(theater: '1939-12-25'), posters: double(original: 'an image link'), synopsis: 'a synopsis', critics_consensus: 'a review', year: 2001
  end
end

helpers do
  def films
    Cache.new.get_films settings.postcode, settings.lookahead, settings.max_cinemas
  end
end

get '/films' do
  content_type :json
  films.to_json
end

get '/films/:id' do
  films[params[:id].to_i - 1].to_json
end

get '/films;clear_cache' do
  Cache.new.clear
end

get '/' do
  erb :index
end
