require 'film_augmenter'

describe FilmAugmenter do
  let (:cinema) { double }
  let (:film) { Film.new 'a film', 1979, cinema, Date.new(2001, 12, 25), 'a time' }
  let (:details) { double }
  let (:data_source) { double }
  let (:rotten_tomatoes) { double }
  let (:augmenter) { FilmAugmenter.new data_source, rotten_tomatoes }

  it 'should add a link to the film' do
    allow(data_source).to receive(:get_films).and_return [film] 
    allow(rotten_tomatoes).to receive(:get_details).and_return details
    allow(details).to receive(:link).and_return 'a link'

    films = augmenter.get_films 'a postcode', 7
    expect(films).to eq [film]
    expect(film.link).to eq 'a link'
  end
end
