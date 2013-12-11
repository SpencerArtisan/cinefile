require 'sinatra'
require 'film'
require 'cached_data_source'

set :root, File.join(File.dirname(__FILE__), '..')

helpers do
  def datasource
    CachedDataSource.new DataSource.new
  end
end

get '/films' do
  content_type :json
  films = Film.all datasource, 7
  films.to_json
end

get '/' do
  erb :index
end
