require 'cinema'

Film = Struct.new(:title, :year, :cinema, :when) do
  def self.all(datasource, days)
    films = []
    Cinema.all(datasource).each {|cinema| films.concat cinema.get_films(datasource, days) }

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
