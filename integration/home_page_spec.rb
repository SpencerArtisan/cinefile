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

    #it 'should have a link to the film' do
      #expect(page).to have_xpath "//a[@href='a link']"
    #end

    #it 'should show the film rating' do
      #expect(page).to have_content '92%'
    #end

    #it 'should show the film cinemas' do
      #expect(page).to have_content 'Renoir'
    #end

    #it 'should show the film times' do
      #expect(page).to have_content '13:30 18:20'
    #end

    #it 'should show the film dates' do
      #puts page.body
      #expect(page).to have_content Date.today.strftime("%a %-d %b")
    #end
  end
end
