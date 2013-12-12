require 'cinema'

class Film
  attr_accessor :title, :year

  def initialize title, year, cinema, day_on
    self.title = title
    self.year = year
    add_showing cinema, day_on
  end

  def add_showing cinema, day_on
    showings << OpenStruct.new(cinema: cinema, day_on: day_on)
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
    puts "Starting Merging #{films.length} films"
    films.each do |film|
      existing_showing = merged_films[film.title]
      if existing_showing
        existing_showing.merge film
      else
        merged_films[film.title] = film.clone
      end
    end
    merged_films.values
  end

  def merge another_film
    puts "Merging #{another_film.showings.length} showings for film #{title}.  Now has #{showings.length} showings"
    showings.concat another_film.showings
  end

  def showings
    @showings ||= []
  end

  def to_hash
    showings_hash = showings.map {|showing| {cinema: showing.cinema.name, day_on: showing.day_on}}
    {title: title, year: year, showings: showings_hash}
  end

  def to_json
    to_hash.to_json
  end
end
