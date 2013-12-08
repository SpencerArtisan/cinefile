ENV['RACK_ENV'] = 'test'

require 'cinefile'
require 'capybara'
require 'capybara/dsl'

describe 'Cinefile' do
  include Capybara::DSL

  before do
    Capybara.app = Sinatra::Application.new
  end

  it 'should be able to get a list of films' do
    visit '/films'
    expect(page).to have_content 'Gone With The Wind'
  end
end
