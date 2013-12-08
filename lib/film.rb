class Film
  def self.all
    films = []
    Venue.all.each {|venue| films.concat venue.films }
    films
  end
end
