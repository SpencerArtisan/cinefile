require 'film'
require 'rottentomatoes'
require 'unreliable_object_delegate'

include RottenTomatoes
Rotten.api_key = 'khyrfh8p43auq75j5eh66gae'

class FilmAugmenter
  def initialize data_source
    @data_source = data_source
  end

  def get_films postcode, days, max_cinemas
    films = @data_source.get_films postcode, days, max_cinemas
    films.each do |film|
      begin
        augment film
      rescue Exception => e
        puts "Exception whilst augmenting #{film.title}: #{e.inspect}"
      end
    end
    films
  end

  def augment film
    puts "AUGMENTING #{film.title}"
    matches = UnreliableObjectDelegate.new(self, 10, 10).find_rotten_movie film
    if matches.is_a? Array
      if matches.length > 0
        augment_with_movie film, best_match(film, matches)
      end
    elsif !matches.nil?
      augment_with_movie film, matches
    end
  end

  def find_rotten_movie film
    RottenMovie.find title: film.title
  end

  def augment_with_movie film, rotten_movie
    film.link = rotten_movie.links.alternate
    film.rating = rotten_movie.ratings.critics_score
    film.rating = rotten_movie.ratings.audience_score unless film.rating
  end

  def best_match film, matches
    closest_match = matches[0]
    matches.each {|match| closest_match = match if is_closer_match?(film, match, closest_match) }
    closest_match
  end

  def is_closer_match? film, match, closest_match
    year_gap(film, match) < year_gap(film, closest_match)  
  end

  def year_gap film, movie
    (film.year - movie.release_dates.theater.to_i).abs
  end
end
