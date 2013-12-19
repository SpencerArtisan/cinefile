ENV['RACK_ENV'] = 'test'

require 'test_environment'
require 'cinefile'
require 'capybara'
require 'capybara/rspec'
require 'capybara-webkit'

Capybara.app = Sinatra::Application.new
Capybara.javascript_driver = :webkit

describe 'Cinefile' do
  include Capybara::DSL

  before do
    allow_any_instance_of(FindAnyFilm).to receive(:read_films).and_return File.read('find_any_film_sample.json')
    allow_any_instance_of(FindAnyFilm).to receive(:read_cinemas).and_return File.read('cinemas_sample.html')
    details = double links: double(alternate: 'a link'), ratings: double(critics_score: 92)
    allow(RottenMovie).to receive(:find).and_return details
    visit '/films/clear_cache'
    visit '/films'
  end

  context 'Selecting a film', js: true do
    before do
      visit '/'
      click_on 'Gone With The Wind (1939) (PG)'
    end

    it 'should show the rotten tomatoes details' do
      puts page.body
      expect(page).to have_xpath "//object"
      expect(page).to have_xpath "//object[@data='a link']"
    end

    #it 'should be able to return to the film list' do
      #click_on 'back'
      #puts page.body
      #expect(page).to have_content 'Of Gods And Men'
    #end
  end
end
