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
      first("span", text: 'Gone With The Wind (1939)').click
    end

    it 'should show the film review' do
      expect(page).to have_content 'a review'
    end

    it 'should show the film title' do
      expect(page).to have_content 'Gone With The Wind'
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

    it 'should show the film date' do
      expect(page).to have_content Date.today.strftime("%A %-d %B")
    end
  end
end
