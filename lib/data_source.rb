require 'nokogiri'
require 'open-uri'
require 'json'
require 'film'
require 'find_any_film'

class DataSource
  def self.get_films venue_id
    day = 1

    response = FindAnyFilm.get_films venue_id

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
      rescue NoMethodError
        title = ""
      end

      data << Film.new(title)
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
end
