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
    allow(FindAnyFilm).to receive(:get_films).and_return File.read('find_any_film_sample.json')
    allow(FindAnyFilm).to receive(:find_cinemas).and_return File.read('cinemas_sample.html')
  end

  it 'should be able to get a list of films' do
    visit '/films'
    expect(page).to have_content 'Gone With The Wind'
  end

  context 'showing the home page', js: true do
    before do
      visit '/films/clear_cache'
      visit '/'
    end

    it 'should show the film names' do
      expect(page).to have_content 'Gone With The Wind'
    end

    it 'should show the film cinemas' do
      expect(page).to have_content 'BFI Southbank'
    end

    #it 'should show the film dates' do
      #puts page.body
      #expect(page).to have_content Date.today.strftime("%a %-d %b")
    #end
  end
end
