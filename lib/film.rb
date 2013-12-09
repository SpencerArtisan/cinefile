require 'venue'

Film = Struct.new(:title, :year, :cinema, :when) do
  def self.all(days)
    films = []
    Venue.all.each {|venue| films.concat venue.get_films(days) }

    def films.to_json
      {films: map {|film| film.to_hash}}.to_json
    end

    films
  end

  def to_hash
    {title: title, year: year, cinema: cinema.name, when: self.when}
  end

  def to_json
    to_hash.to_json
  end
end
