require 'venue'

Film = Struct.new(:title, :year) do
  def self.all
    films = []
    Venue.all.each {|venue| films.concat venue.films }

    def films.to_json
      {films: map {|film| film.to_json}}.to_json
    end

    films
  end

  def to_json
    {title: title, year: year}.to_json
  end
end
