ENV['RACK_ENV'] = 'test'

require 'test_environment'
require 'cinefile'
require 'capybara'
require 'capybara/rspec'
require 'capybara-webkit'

# use the rackup file to load the apps w/their respective URL mappings, sweet!

describe 'Cinefile' do
  include Capybara::DSL

  before do
    Capybara.app = Sinatra::Application.new
    Capybara.javascript_driver = :webkit
    allow_any_instance_of(FindAnyFilm).to receive(:read_films).and_return File.read('find_any_film_sample.json')
    allow_any_instance_of(FindAnyFilm).to receive(:read_cinemas).and_return File.read('cinemas_sample.html')
    details = double links: double(alternate: 'a link'), ratings: double(critics_score: 92)
    allow(RottenMovie).to receive(:find).and_return details
    visit '/films/clear_cache'
  end

  it 'should be able to get a list of films' do
    visit '/films'
    expect(page).to have_content 'Gone With The Wind'
  end

  context 'showing the home page', js: true do
    before do
      visit '/'
    end

    it 'should show the film names' do
      expect(page).to have_content 'Gone With The Wind'
    end

    it 'should have a link to the film' do
      expect(page).to have_xpath "//a[@href='a link']"
    end

    it 'should show the film rating' do
      expect(page).to have_content '92%'
    end

    it 'should show the film cinemas' do
      expect(page).to have_content 'Renoir'
    end

    it 'should show the film times' do
      expect(page).to have_content '13:30 18:20'
    end

    #it 'should show the film dates' do
      #puts page.body
      #expect(page).to have_content Date.today.strftime("%a %-d %b")
    #end
  end
end
