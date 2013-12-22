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
    films.each_with_index do |film, i|
      begin
        augment film
        film.id = i + 1
      rescue Exception => e
        puts "Exception whilst augmenting #{film.title}: #{e.inspect}"
        puts e.backtrace
      end
    end
    films
  end

  def augment film
    puts "AUGMENTING #{film.title}"
    matches = UnreliableObjectDelegate.new(self, 10, 30).find_rotten_movie film
    matches = [matches] unless matches.is_a?(Array)
    augment_with_movie(film, best_match(film, matches)) if matches.length > 0
  end

  def find_rotten_movie film
    RottenMovie.find title: film.title
  end

  def augment_with_movie film, rotten_movie
    return unless rotten_movie
    film.link = rotten_movie.links.alternate
    film.synopsis = rotten_movie.synopsis
    film.review = rotten_movie.critics_consensus
    film.image = rotten_movie.posters.original
    film.rating = rotten_movie.ratings.critics_score
    film.rating = rotten_movie.ratings.audience_score unless film.rating && film.rating != -1
    film.rating = nil if film.rating == -1
  end

  def best_match film, matches
    closest_match = matches[0]
    matches.each {|match| closest_match = match if is_closer_match?(film, match, closest_match) }
    year_gap(film, closest_match) < 5 ? closest_match : nil
  end

  def is_closer_match? film, match, closest_match
    year_gap(film, match) < year_gap(film, closest_match)  
  end

  def year_gap film, movie
    (film.year - movie.release_dates.theater.to_i).abs
  end
end
