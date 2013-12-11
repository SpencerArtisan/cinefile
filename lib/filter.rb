class Filter
  def initialize datasource
    @datasource = datasource
  end

  def get_films cinema, day
    films = @datasource.get_films cinema, day
    films.select {|film| film.year < 1980}
  end

  def find_cinemas postcode
    cinemas = @datasource.find_cinemas postcode
    cinemas[0..49]
  end
end
