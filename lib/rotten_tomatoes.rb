require 'json'
require 'rest-client'

class RottenTomatoes
  KEY = "khyrfh8p43auq75j5eh66gae"

  def get_details film
    url = "http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=#{KEY}&q=#{CGI::escape(film.title)}&page_limit=1"
    puts "Calling #{url}"
    result = RestClient.get url

    json = JSON.parse result
    link = json["movies"][0]["links"]["alternate"]
    return OpenStruct.new link: link
  end
end
