require 'nokogiri'
require 'open-uri'
require 'json'
require 'film'
require 'find_any_film'

class DataSource
  def get_films cinema, day
    films = film_nodes(cinema, day).map { |node| extract_film(node, cinema, day) }
    films.compact
  end

  def film_nodes cinema, day
    doc = films_dom cinema, day
    show_times = doc.xpath("/html/body/div[@class='times']//tr")
  end

  def films_dom cinema, day
    response = FindAnyFilm.get_films cinema, day
    doc = JSON.parse(response)
    Nokogiri::HTML(doc['html'])
  end

  def extract_film node, cinema, day
    begin
      title, year = extract_title_and_year node
      times = extract_times node
      Film.new(title, year, cinema, Date.today + day - 1)
    rescue Exception
      puts "Couldn't handle film node #{node.inspect}"
      nil
    end
  end

  def extract_title_and_year node
    node = node.xpath(".//td[@class='title']/a")
    title = node.children.first.content
    title = title.gsub!(/\s+/, " ").strip!
    year = title.scan(/\((\d{4})\)/)[0][0].to_i
    [title, year]
  end

  def extract_times node
    times = ""
    node = node.xpath(".//td[@class='times']")
    node.each_with_index do |td, i|                                                                        
      # it's also the value of a link
      td.children.each do |e|  
        time = e.content
        # clean it up
        time.gsub!(/\s+/, " ").strip!

        # annoyingly, it has empty tags around it
        if not time.empty?
          times = "#{times}#{time} "
        end  
      end
    end
    times
  end

  def find_cinemas postcode
    cinema_nodes(postcode).map { |node| extract_cinema(node) }
  end

  def cinema_nodes postcode
    doc = Nokogiri::HTML(FindAnyFilm.find_cinemas(postcode))
    cinemas = doc.xpath("/html/body//div[@id='content']//div[@class='cinema']/div/div")
    cinemas.xpath("//h2/a")
  end

  def extract_cinema node
    title = node.children.first.content
    title = title.gsub!(/\s+/, " ").strip!.split(',')[0]
    node = node.attribute("href").content
    cinema_id = node.split(/[?&]/)[1]
    cinema_id = cinema_id.split(/[=]/)[1]
    Cinema.new(cinema_id, title)
  end
end
