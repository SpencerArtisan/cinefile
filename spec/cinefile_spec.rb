ENV['RACK_ENV'] = 'test'

require 'cinefile'
require 'rack/test'

class Film; end

describe 'Cinefile' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let (:films) { double }

  it 'should be able to get a list of films' do
    allow(Film).to receive(:all).and_return films
    allow(films).to receive(:to_json).and_return 'some json'
    get '/films'
    expect(last_response).to be_ok
    expect(last_response.body).to eq 'some json'
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
