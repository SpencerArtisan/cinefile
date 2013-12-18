require 'rottentomatoes'
require 'film_augmenter'

include RottenTomatoes
Rotten.api_key = 'khyrfh8p43auq75j5eh66gae'

describe RottenTomatoes do
  it 'should have a link for Dead of Night' do
    matches = RottenMovie.find title: 'Dead Of Night (1945) (PG)'
    puts matches
  end

  let (:cinema) { double }
  let (:film) { Film.new 'Dead Of Night (1945) (PG)', 1945, cinema, Date.new(2001, 12, 25), 'a time' }
  let (:data_source) { double }
  let (:augmenter) { FilmAugmenter.new data_source }

  it 'should augment the film' do
    allow(data_source).to receive(:get_films).and_return [film] 
    films = augmenter.get_films 'a postcode', 7, 42
    p films[0]
  end
end
