require 'film_augmenter'

describe FilmAugmenter do
  let (:cinema) { double }
  let (:film) { Film.new 'a film', 1979, cinema, Date.new(2001, 12, 25), 'a time' }
  let (:details) { double.as_null_object }
  let (:data_source) { double }
  let (:rotten_tomatoes) { double }
  let (:augmenter) { FilmAugmenter.new data_source, rotten_tomatoes }

  before do
    allow(data_source).to receive(:get_films).and_return [film] 
    allow(rotten_tomatoes).to receive(:get_details).and_return details
  end

  it 'should return the same films' do
    films = augmenter.get_films 'a postcode', 7
    expect(films).to eq [film]
  end

  it 'should add a link to the film' do
    allow(details).to receive(:link).and_return 'a link'
    augmenter.get_films 'a postcode', 7
    expect(film.link).to eq 'a link'
  end

  it 'should add a rating for the film' do
    allow(details).to receive(:rating).and_return 42
    augmenter.get_films 'a postcode', 7
    expect(film.rating).to eq 42
  end
end
