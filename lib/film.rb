require 'venue'

Film = Struct.new(:title, :year, :cinema) do
  def self.all(days)
    films = []
    Venue.all.each {|venue| films.concat venue.get_films(days) }

    def films.to_json
      {films: map {|film| film.to_json}}.to_json
    end

    films
  end

  def to_json
    {title: title, year: year, cinema: cinema.name}.to_json
  end
end
