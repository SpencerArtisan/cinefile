class FilmFilter
  def initialize datasource
    @datasource = datasource
  end

  def get_films cinema, day
    films = @datasource.get_films cinema, day
    films.select {|film| film.year < 1980}
  end

  def find_cinemas postcode, max_cinemas
    cinemas = @datasource.find_cinemas postcode
    cinemas[0..max_cinemas-1]
  end
end
