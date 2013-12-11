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
  let (:datasource) { double }

  before do
    allow(CachedDataSource).to receive(:new).and_return datasource
  end

  it 'should be able to get a list of films' do
    allow(Film).to receive(:all).and_return films
    allow(films).to receive(:to_json).and_return 'some json'
    get '/films'
    expect(last_response).to be_ok
    expect(last_response.body).to eq 'some json'
  end

  it 'should be able to clear the cache' do
    expect(datasource).to receive(:clear)
    get '/films/clear_cache'
    expect(last_response).to be_ok
  end

  context 'showing the home page' do
    before do
      allow(Film).to receive(:all).and_return films
      allow(films).to receive(:to_json).and_return '{"films":[]}'
      get '/'
    end

    it 'should return http success' do
      expect(last_response).to be_ok
    end
  end
end
