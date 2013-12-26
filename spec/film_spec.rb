require 'film'
require 'timecop'

describe Film do
  let (:datasource) { double }
  let (:cinema) { double name: 'a cinema' }
  let (:film) { Film.new 'a film (1934) (U)', 1979, cinema, Date.new(2001, 12, 25), 'some times' }

  it 'should have a showing' do
    expect(film).to have(1).showings
  end

  it 'should strip off the rating from the title' do
    film.title = "Casablanca (1942) (15)"
    expect(film.title).to eq "Casablanca (1942)"
  end

  it 'should work without ratings' do
    film = Film.new 'Casablanca (1942)', 1979, cinema, Date.new(2001, 12, 25), 'some times'
    expect(film.title).to eq "Casablanca (1942)"
  end

  it 'should convert a single film to json' do
    film.rating = 42
    film.image = 'an image'
    film.language = 'a language'
    film.review = 'a review'
    expect(film.to_json).to eq('{"title":"a film (1934)","year":1979,"rating":42,"image":"an image","review":"a review","language":"a language","showings":[{"cinema":"a cinema","day_on":"2001-12-25","times_on":"some times"}]}')
  end
end
