class FilmAugmenter
  def initialize data_source, rotten_tomatoes
    @data_source = data_source
    @rotten_tomatoes = rotten_tomatoes
  end

  def get_films cinema, day
    films = @data_source.get_films cinema, day
    films.each do |film|
      details = @rotten_tomatoes.get_details film
      film.link = details.link
    end
  end
end
