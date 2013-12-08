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
    allow(films).to receive(:to_json).and_return 'some json'
    allow(Film).to receive(:all).and_return films
    get '/films'
    expect(last_response).to be_ok
    expect(last_response.body).to eq 'some json'
  end
end
