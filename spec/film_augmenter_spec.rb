require 'film_augmenter'

describe FilmAugmenter do
  let (:cinema) { double }
  let (:film) { double }
  let (:details) { double }
  let (:data_source) { double }
  let (:rotten_tomatoes) { double }
  let (:augmenter) { FilmAugmenter.new data_source, rotten_tomatoes }

  it 'should add a link to the film' do
    allow(data_source).to receive(:get_films).and_return [film] 
    allow(rotten_tomatoes).to receive(:get_details).and_return details
    allow(details).to receive(:link).and_return 'a link'

    expect(film).to receive(:link=).with('a link')
    films = augmenter.get_films cinema, 1
    expect(films).to eq [film]
  end
end
