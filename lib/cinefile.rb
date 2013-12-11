require 'sinatra'
require 'film'

set :root, File.join(File.dirname(__FILE__), '..')

helpers do
  def datasource
    CachedDataSource.new DataSource.new
  end
end

get '/films' do
  content_type :json
  films = Film.all datasource, 1
  films.to_json
end

get '/' do
  erb :index
end
