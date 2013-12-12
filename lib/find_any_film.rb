require 'open-uri'
require 'rest-client'

class FindAnyFilm
  def self.get_films cinema, day
    url = "http://www.findanyfilm.com/find-a-cinema-3?day=%s&venue_id=%s&action=Screenings&townpostcode=" % [day, cinema.id]
    RestClient.get url
  end

  def self.find_cinemas postcode
    open('http://www.findanyfilm.com/find-a-cinema-3?townpostcode=' + postcode)
  end
end
