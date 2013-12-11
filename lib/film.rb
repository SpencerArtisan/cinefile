require 'cinema'

class Film
  attr_accessor :title, :year

  def initialize title, year, cinema, when_showing
    self.title = title
    self.year = year
    add_showing cinema, when_showing
  end

  def add_showing cinema, when_showing
    showings << OpenStruct.new(cinema: cinema, when: when_showing)
  end

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
    showings.concat another_film.showings
  end

  def showings
    @showings ||= []
  end

  def to_hash
    showings_hash = showings.map {|showing| {cinema: showing.cinema.name, when: showing.when}}
    {title: title, year: year, showings: showings_hash}
  end

  def to_json
    to_hash.to_json
  end
end
