require 'nokogiri'
require 'open-uri'
require 'json'
require 'film'
require 'find_any_film'

class DataSource
  def get_films cinema, day
    film_nodes(cinema, day).map { |node| extract_film(node, cinema, day) }
  end

  def film_nodes cinema, day
    doc = films_dom cinema, day
    show_times = doc.xpath("/html/body/div[@class='times']//tr")
    show_times.xpath("//td[@class='title']/a")
  end

  def films_dom cinema, day
    response = FindAnyFilm.get_films cinema, day
    doc = JSON.parse(response)
    Nokogiri::HTML(doc['html'])
  end

  def extract_film node, cinema, day
    title = node.children.first.content
    title = title.gsub!(/\s+/, " ").strip!
    year = title.scan(/\((\d{4})\)/)[0][0].to_i
    Film.new(title, year, cinema, Date.today + day - 1)
  end

  def find_cinemas post_code
    cinema_nodes(post_code)[0..49].map { |node| extract_cinema(node) }
  end

  def cinema_nodes post_code
    doc = Nokogiri::HTML(FindAnyFilm.find_cinemas(post_code))
    cinemas = doc.xpath("/html/body//div[@id='content']//div[@class='cinema']/div/div")
    cinemas.xpath("//h2/a")
  end

  def extract_cinema node
    title = node.children.first.content
    title = title.gsub!(/\s+/, " ").strip!.split(',')[0]
    node = node.attribute("href").content
    venue_id = node.split(/[?&]/)[1]
    venue_id = venue_id.split(/[=]/)[1]
    Venue.new(venue_id, title)
  end
end
