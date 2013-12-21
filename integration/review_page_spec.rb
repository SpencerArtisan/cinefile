require_relative './spec_helper'

describe 'Cinefile' do
  include Capybara::DSL

  before do
    mock_external_components
    reload_cache
  end

  context 'Selecting a film', js: true do
    before do
      visit '/'
      click_on 'Gone With The Wind (1939) (PG)'
      click_on 'Reviews'
    end

    it 'should show the rotten tomatoes details' do
      expect(page).to have_xpath "//object"
      expect(page).to have_xpath "//object[@data='a link']"
    end
  end
end
