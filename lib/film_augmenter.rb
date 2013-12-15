require 'film'

class FilmAugmenter
  def initialize data_source, rotten_tomatoes
    @data_source = data_source
    @rotten_tomatoes = rotten_tomatoes
  end

  def get_films postcode, days, max_cinemas
    films = @data_source.get_films postcode, days, max_cinemas
    puts "AUGMENTING #{films.map(&:title)}..."
    films.each do |film|
      details = @rotten_tomatoes.get_details film
      film.link = details.link
      film.rating = details.rating
    end
  end
end
