require_relative './spec_helper'

describe 'Showings page' do
  include Capybara::DSL

  before do
    mock_external_components
    reload_cache
  end

  context 'Selecting a film', js: true do
    before do
      visit '/'
      click_on 'Gone With The Wind (1939) (PG)'
      click_on 'Showings'
    end

    it 'should show the film cinemas' do
      expect(page).to have_content 'Renoir'
    end

    it 'should show the film times' do
      expect(page).to have_content '13:30 18:20'
    end
  end
end

