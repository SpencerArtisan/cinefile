require 'nokogiri'
require 'open-uri'
require 'json'
require 'film'
require 'find_any_film'

class DataSource
  def self.get_films cinema, day
    response = FindAnyFilm.get_films cinema, day

    # extract the HTML from the JSON response
    doc = JSON.parse(response)
    doc = doc["html"]

    # parse it
    doc = Nokogiri::HTML(doc)

    # extract the showtimes block
    show_times = doc.xpath("/html/body/div[@class='times']//tr")

    # don't process more if there's nothing to process
    if show_times.to_html.include? "Sorry, there are no screenings"
      return []
    end

    data = []

    # link holds a url for the film and the title
    show_times.xpath("//td[@class='title']/a").each { |a|
      # grab the url and clean it
      link = a.attribute("href").value

      # grab the title and clean it
      begin
        title = a.children.first.content
        title = title.gsub!(/\s+/, " ").strip!
        year = title.scan(/\((\d{4})\)/)[0][0].to_i
      rescue NoMethodError
        title = ""
        year = nil
      end

      data << Film.new(title, year, cinema)
    }

    # extract the times the film is showing
    #show_times.xpath("//td[@class='times']").each_with_index { |td, i|
      #showing = data[i]

      ## it's also the value of a link
      #td.children.each { |e|
        #time = e.content
        ## clean it up
        #time.gsub!(/\s+/, " ").strip!

        ## annoyingly, it has empty tags around it
        #if not time.empty?
          #showing["time"].push(time)
        #end
      #}
    #}

    data
  end

  def self.find_cinemas post_code
    # open it in nokogiri
    doc = Nokogiri::HTML(FindAnyFilm.find_cinemas(post_code))

    # parse the main 'cinemas' block
    cinemas = doc.xpath("/html/body//div[@id='content']//div[@class='cinema']/div/div")

    # hold the cinema data
    data = []

    # nokogiri thinks this is much deeper
    cinemas.xpath("//h2/a").each { |link|
      # title is the link text, then only keep the text
      title = link.children.first.content
      title.gsub!(/\s+/, " ").strip!
      title = title.split(',')[0]

      # extract the actual link
      link = link.attribute("href").content
      # venue id is the first parameter
      venue_id = link.split(/[?&]/)[1]
      # then break the parameter open
      venue_id = venue_id.split(/[=]/)[1]

      data << Venue.new(venue_id, title)
      break if data.size == 50
    }

    data
  end
end
