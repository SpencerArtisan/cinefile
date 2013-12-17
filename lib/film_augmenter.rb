require 'film'
require 'rottentomatoes'

include RottenTomatoes
Rotten.api_key = 'khyrfh8p43auq75j5eh66gae'

class FilmAugmenter
  def initialize data_source
    @data_source = data_source
  end

  def get_films postcode, days, max_cinemas
    films = @data_source.get_films postcode, days, max_cinemas
    puts "AUGMENTING #{films.map(&:title)}..."
    films.each do |film|
      matches = RottenMovie.find(title: film.title)
      if matches.is_a? Array
        augment(film, best_match(film, matches)) 
      elsif !matches.nil?
        augment(film, matches) 
      end
    end
    films
  end
  
  def best_match film, matches
    closest_match = matches[0]
    matches.each {|match| closest_match = match if (match.year - film.year).abs < (closest_match.year - film.year).abs}
    closest_match
  end

  def augment film, rotten_movie
    film.link = rotten_movie.links.alternate
    film.rating = rotten_movie.ratings.critics_score
    film.rating = rotten_movie.ratings.audience_score unless film.rating
  end
end
