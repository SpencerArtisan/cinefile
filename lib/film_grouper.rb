require 'film'

class FilmGrouper
  def initialize datasource
    @datasource = datasource
  end

  def get_films postcode, days
    cinemas = @datasource.find_cinemas postcode
    films = []
    cinemas.each {|cinema| films.concat get_cinema_films(cinema, days) }
    films = merge_matching_films films


    films
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

