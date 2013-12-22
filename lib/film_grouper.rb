require 'film'

class FilmGrouper
  def initialize datasource
    @datasource = datasource
  end

  def get_films postcode, days, max_cinemas
    cinemas = @datasource.find_cinemas postcode, max_cinemas
    films = []
    cinemas.each {|cinema| films.concat get_cinema_films(cinema, days) }
    merged = merge_matching_films films
    merged.sort! {|film1, film2| film1.title <=> film2.title}
  end

  def get_cinema_films cinema, days
    all_films = []
    1.upto(days) {|day| all_films.concat(@datasource.get_films cinema, day)}
    all_films
  end

  def merge_matching_films films
    merged_films = {}
    puts "Starting Merging #{films.length} films"
    films.each do |film|
      existing_film = merged_films[film.title]
      if existing_film
        existing_film.merge film
      else
        merged_films[film.title] = film
      end
    end
    merged_films.values
  end

end

