require 'cinema'
require 'ostruct'
require 'json'

class Film
  attr_accessor :year, :link, :rating, :id, :review, :synopsis, :image, :language

  def initialize title, year, cinema, day_on, times_on
    @title = title
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

  def title= value
    @title = value
  end

  def title 
    @title =~ /(.*)\) \(\S*\)/ ? @title.scan(/(.*) \(\S*\)/)[0][0] : @title
  end

  def to_hash
    showings_hash = showings.map {|showing| {cinema: showing.cinema.name, day_on: showing.day_on, times_on: showing.times_on}}
    {id: id, title: title, year: year, link: link, rating: rating, image: image, synopsis: synopsis, review: review, language: language, showings: showings_hash}
  end

  def to_json
    to_hash.to_json
  end
end
