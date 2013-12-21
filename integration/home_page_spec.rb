require_relative './spec_helper'

describe 'Cinefile' do
  include Capybara::DSL

  before do
    mock_external_components
    reload_cache
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
  end
end
