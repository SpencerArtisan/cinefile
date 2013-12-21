ENV['RACK_ENV'] = 'test'

require 'test_environment'
require 'cinefile'
require 'rack/test'

describe 'Cinefile' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let (:films) { double }
  let (:film) { double }
  let (:cache) { double }

  before do
    allow(Cache).to receive(:new).and_return cache
  end

  it 'should be able to get a list of films' do
    allow(cache).to receive(:get_films).and_return films
    allow(films).to receive(:to_json).and_return 'some json'
    get '/films'
    expect(last_response).to be_ok
    expect(last_response.body).to eq 'some json'
  end

  it 'should be able to get a specific films' do
    allow(cache).to receive(:get_films).and_return [film]
    allow(film).to receive(:to_json).and_return 'some json'
    get '/films/0'
    expect(last_response).to be_ok
    expect(last_response.body).to eq 'some json'
  end

  it 'should be able to clear the cache' do
    expect(cache).to receive(:clear)
    get '/films;clear_cache'
    expect(last_response).to be_ok
  end

  context 'showing the home page' do
    before do
      allow(cache).to receive(:get_films).and_return films
      allow(films).to receive(:to_json).and_return '{"films":[]}'
      get '/'
    end

    it 'should return http success' do
      expect(last_response).to be_ok
    end
  end
end
