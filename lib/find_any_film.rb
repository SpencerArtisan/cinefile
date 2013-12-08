require 'open-uri'
require 'rest-client'

class FindAnyFilm
  def self.get_films venue_id, day
    url = "http://www.findanyfilm.com/find-a-cinema-3?day=%s&venue_id=%s&action=Screenings&townpostcode=" % [day, venue_id]
    RestClient.get url
  end
end
