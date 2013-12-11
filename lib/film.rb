require 'cinema'

Film = Struct.new(:title, :year, :cinema, :when) do
  def self.all(datasource, days)
    films = []
    Cinema.all(datasource).each {|cinema| films.concat cinema.get_films(datasource, days) }
    films = merge_matching_films(films)

    def films.to_json
      {films: map {|film| film.to_hash}}.to_json
    end

    films
  end

  def self.merge_matching_films films
    merged_films = {}
    films.each do |film|
      existing_showing = merged_films[film.title]
      if existing_showing
        existing_showing.merge film
      else
        merged_films[film.title] = film
      end
    end
    merged_films.values
  end

  def merge another_film
    self
  end

  def when_formatted
    self.when.strftime "%a %-d %b"
  end

  def to_hash
    {title: title, year: year, cinema: cinema.name, when: self.when}
  end

  def to_json
    to_hash.to_json
  end
end
