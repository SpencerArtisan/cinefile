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
      click_on 'by-date'
    end

    it 'should show the film names' do
      expect(page).to have_content 'Gone With The Wind'
    end
  end
end

