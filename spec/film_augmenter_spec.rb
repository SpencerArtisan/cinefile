require 'film_augmenter'

describe FilmAugmenter do
  let (:cinema) { double }
  let (:data_source) { double }
  let (:film) { Film.new 'a film', 1979, cinema, Date.new(2001, 12, 25), 'a time' }
  let (:rotten_movie) { double.as_null_object }
  let (:augmenter) { FilmAugmenter.new data_source }

  before do
    allow(data_source).to receive(:get_films).and_return [film] 
  end

  context 'When rotten tomatoes matches with no movies' do
    before do
      allow(RottenMovie).to receive(:find).and_return nil
    end

    it 'should return the same films as the datasource' do
      films = augmenter.get_films 'a postcode', 7, 42
      expect(films).to eq [film]
    end

    it 'should leave the link as nil' do
      films = augmenter.get_films 'a postcode', 7, 42
      expect(films[0].link).to be_nil
    end

    it 'should leave the rating as nil' do
      films = augmenter.get_films 'a postcode', 7, 42
      expect(films[0].rating).to be_nil
    end
  end

  context 'When rotten tomatoes matches with one movie' do
    before do
      allow(RottenMovie).to receive(:find).and_return rotten_movie
    end

    it 'should return the same films as the datasource' do
      films = augmenter.get_films 'a postcode', 7, 42
      expect(films).to eq [film]
    end

    it 'should add a link to the film' do
      allow(rotten_movie).to receive(:links).and_return double(alternate: 'a link')
      augmenter.get_films 'a postcode', 7, 42
      expect(film.link).to eq 'a link'
    end

    context 'A critics rating is available' do
      before do
        allow(rotten_movie).to receive(:ratings).and_return double(critics_score: 96)
      end

      it 'should use the critics rating' do
        augmenter.get_films 'a postcode', 7, 42
        expect(film.rating).to eq 96
      end
    end

    context 'A critics rating is not available' do
      before do
        allow(rotten_movie).to receive(:ratings).and_return double(critics_score: nil, audience_score: 96)
      end

      it 'should use the audience rating' do
        augmenter.get_films 'a postcode', 7, 42
        expect(film.rating).to eq 96
      end
    end
  end
end
