ENV['RACK_ENV'] = 'test'

require 'cinefile'
require 'capybara'
require 'capybara/dsl'

describe 'Cinefile' do
  include Capybara::DSL

  before do
    Capybara.app = Sinatra::Application.new
    allow(FindAnyFilm).to receive(:get_films).and_return File.read('find_any_film_sample.json')
    allow(FindAnyFilm).to receive(:find_cinemas).and_return File.read('cinemas_sample.html')
  end

  it 'should be able to get a list of films' do
    visit '/films'
    expect(page).to have_content 'Gone With The Wind'
  end

  context 'showing the home page' do
    it 'should show the film names' do
      visit '/'
      puts page.body
      #expect(page).to have_content 'Gone With The Wind'
    end
  end
end
