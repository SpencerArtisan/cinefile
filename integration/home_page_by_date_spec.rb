require_relative './spec_helper'

describe 'Cinefile' do
  include Capybara::DSL

  before do
    mock_external_components
    reload_cache
  end

  context 'clicking the date icon on the home page', js: true do
    before do
      visit '/'
      find('#by-date').click
    end

    it 'should show the film names' do
      expect(page).to have_content 'Gone With The Wind'
    end

    it 'should show the film date' do
      expect(page).to have_content Date.today.strftime("%A %-d %B")
    end
  end
end

