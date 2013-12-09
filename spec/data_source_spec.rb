require 'data_source'

class FindAnyFilm; end

describe DataSource do
  context 'Reading the films' do
    before do
      find_any_film_sample = File.read 'find_any_film_sample.json'
      allow(FindAnyFilm).to receive(:get_films).with(1, 1).and_return find_any_film_sample
      @films = DataSource.get_films(1, 1)
    end

    it 'should get all the films' do
      expect(@films.size).to eq 6
    end

    it 'should get the film title' do
      expect(@films[0].title).to eq 'Gone With The Wind (1939) (PG)'
    end

    it 'should get the film year' do
      expect(@films[0].year).to eq 1939
    end
  end
end
