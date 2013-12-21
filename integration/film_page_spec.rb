require_relative './spec_helper'

describe 'Film page' do
  include Capybara::DSL

  before do
    mock_external_components
    reload_cache
  end

  context 'Selecting a film', js: true do
    before do
      visit '/'
      click_on 'Gone With The Wind (1939) (PG)'
    end

    it 'should show the film rating' do
      expect(page).to have_content '92%'
    end

    it 'should show a Screenings link' do
      expect(page).to have_link 'Screenings'
    end
  end
end
