require 'rest-client'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'film'
require 'find_any_film'

class FindAnyFilm
  def get_films cinema, day
    films = film_nodes(cinema, day).map { |json| extract_film(json[1], cinema, day) }
    films.compact
  end

  def film_nodes cinema, day
    json = films_json cinema, day
    json == 'false' ? [] :JSON.parse(json)[cinema.id]['films']
  end

  def films_json cinema, day
    read_films cinema, day
  end

  def read_films cinema, day
    day_s = (Date.today + day).to_s
    url = "http://www.findanyfilm.com/api/screenings/venue_id/%s/date_from/%s" % [cinema.id, day_s]
    RestClient.get url
  end

  def extract_film json, cinema, day
    begin
      title, year = extract_title_and_year json
      times = extract_times json
      Film.new(title, year, cinema, Date.today + day - 1, times)
    rescue Exception
      puts "Couldn't handle film json #{json}"
      nil
    end
  end

  def extract_title_and_year json
    film_data = json['film_data']
    title = film_data['film_title']
    year = film_data['release_year'].to_i
    [title, year]
  end

  def extract_times json
    times = ""
    json['showings'].each_with_index do |showing, i|
      time = showing['display_showtime']
      times = "#{times}#{time} " unless time.empty? || times.include?(time)
    end
    times.strip
  end

  def find_cinemas postcode
    cinema_nodes(postcode).map { |node| extract_cinema(node) }
  end

  def cinema_nodes postcode
    doc = Nokogiri::HTML(read_cinemas(postcode))
    cinemas = doc.xpath("/html/body//div[@id='wrapper']/section/ul/li[@class='cinemaResult show_hide']")
  end

  def read_cinemas postcode
    open('http://www.findanyfilm.com/find-cinema-tickets?townpostcode=' + postcode)
  end

  def extract_cinema node
    cinema_id = node.attribute("rel").value[11..99]
    title = node.children.first.content.split(',')[0]
    postcode = 'dummy'
    Cinema.new cinema_id, title, postcode
  end
end
