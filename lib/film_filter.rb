require 'forwardable'

class FilmFilter
  def initialize datasource
    @datasource = datasource
  end

  def get_films *args
    @datasource.get_films *args
  end

  def find_cinemas postcode, max_cinemas
    cinemas = @datasource.find_cinemas postcode
    cinemas[0..max_cinemas-1]
  end
end
