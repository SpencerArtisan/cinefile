require 'cinema'
require 'ostruct'
require 'json'

class Film
  attr_accessor :title, :year, :link, :rating

  def initialize title, year, cinema, day_on, times_on
    self.title = title
    self.year = year
    add_showing cinema, day_on, times_on
  end

  def add_showing cinema, day_on, times_on
    showings << OpenStruct.new(cinema: cinema, day_on: day_on, times_on: times_on)
  end

  def merge another_film
    puts "Merging #{another_film.showings.length} showings for film #{title}.  Now has #{showings.length} showings"
    showings.concat another_film.showings
    showings.sort! {|showing1, showing2| showing1.day_on <=> showing2.day_on}
  end

  def showings
    @showings ||= []
  end

  def to_hash
    showings_hash = showings.map {|showing| {cinema: showing.cinema.name, day_on: showing.day_on, times_on: showing.times_on}}
    {title: title, year: year, link: link, rating: rating, showings: showings_hash}
  end

  def to_json
    to_hash.to_json
  end
end
