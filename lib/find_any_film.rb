require 'rest-client'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'film'
require 'find_any_film'

class FindAnyFilm
  def get_films cinema, day
    films = film_nodes(cinema, day).map { |node| extract_film(node, cinema, day) }
    films.compact
  end

  def film_nodes cinema, day
    doc = films_dom cinema, day
    show_times = doc.xpath("/html/body/div[@class='times']//tr")
  end

  def films_dom cinema, day
    response = read_films cinema, day
    doc = JSON.parse(response)
    Nokogiri::HTML(doc['html'])
  end

  def read_films cinema, day
    url = "http://www.findanyfilm.com/find-a-cinema-3?day=%s&venue_id=%s&action=Screenings&townpostcode=" % [day, cinema.id]
    RestClient.get url
  end

  def extract_film node, cinema, day
    begin
      title, year = extract_title_and_year node
      times = extract_times node
      Film.new(title, year, cinema, Date.today + day - 1, times)
    rescue Exception
      puts "Couldn't handle film node #{node.inspect}"
      nil
    end
  end

  def extract_title_and_year node
    node = node.xpath(".//td[@class='title']/a")
    title = node.children.first.content.gsub!(/\s+/, " ").strip!
    year = title.scan(/\((\d{4})\)/)[0][0].to_i
    [title, year]
  end

  def extract_times node
    times = ""
    node = node.xpath(".//td[@class='times']")
    node.each_with_index do |td, i|
      td.children.each do |e|  
        time = e.content.gsub!(/\s+/, " ").strip!
        times = "#{times}#{time} " unless time.empty? || times.include?(time)
      end
    end
    times.strip
  end

  def find_cinemas postcode
    cinema_nodes(postcode).map { |node| extract_cinema(node) }
  end

  def cinema_nodes postcode
    doc = Nokogiri::HTML(read_cinemas(postcode))
    cinemas = doc.xpath("/html/body//div[@id='content']//div[@class='cinema']/div/div")
    cinemas.xpath("//h2/a")
  end

  def read_cinemas postcode
    open('http://www.findanyfilm.com/find-a-cinema-3?townpostcode=' + postcode)
  end

  def extract_cinema node
    cinema_id = node.attribute("href").content.split(/[?&]/)[1].split(/[=]/)[1]
    title = node.children.first.content.gsub!(/\s+/, " ").strip!.split(',')[0]
    Cinema.new(cinema_id, title)
  end
end
