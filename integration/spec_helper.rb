ENV['RACK_ENV'] = 'test'

require 'test_environment'
require 'cinefile'
require 'capybara'
require 'capybara/rspec'
require 'capybara-webkit'

set :lookahead, 1
set :max_cinemas, 1
Capybara.app = Sinatra::Application.new
Capybara.javascript_driver = :webkit

def mock_external_components
  allow_any_instance_of(FindAnyFilm).to receive(:read_films).and_return File.read('find_any_film_sample.json')
  allow_any_instance_of(FindAnyFilm).to receive(:read_cinemas).and_return File.read('cinemas_sample.html')
  details = double links: double(alternate: 'a link'), ratings: double(critics_score: 92), release_dates: double(theater: '1939-12-25'), 
        posters: double(original: 'an image link'), synopsis: 'a synopsis', critics_consensus: 'a review', year: 2001
  allow(RottenMovie).to receive(:find).and_return details
end

def reload_cache
  visit '/films;clear_cache'
  visit '/films'
end
