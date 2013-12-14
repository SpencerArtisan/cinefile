require 'film'
require 'timecop'

describe Film do
  let (:datasource) { double }
  let (:cinema) { double name: 'a cinema' }
  let (:film) { Film.new 'a film', 1979, cinema, Date.new(2001, 12, 25), 'some times' }

  it 'should have a showing' do
    expect(film).to have(1).showings
  end

  it 'should convert a single film to json' do
    film.link = 'a link'
    film.rating = 42
    expect(film.to_json).to eq('{"title":"a film","year":1979,"link":"a link","rating":42,"showings":[{"cinema":"a cinema","day_on":"2001-12-25","times_on":"some times"}]}')
  end
end
