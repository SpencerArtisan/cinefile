require 'data_source'

class FindAnyFilm; end

describe DataSource do
  context 'Reading the films' do
    let (:cinema) { Venue.new 1, 'a cinema' }

    before do
      find_any_film_sample = File.read 'find_any_film_sample.json'
      allow(FindAnyFilm).to receive(:get_films).with(cinema, 1).and_return find_any_film_sample
      @films = DataSource.get_films(cinema, 1)
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

    it 'should get the film cinema' do
      expect(@films[0].cinema).to equal cinema
    end
  end

  context 'Reading the cinemas' do
    before do
      cinemas = File.read 'cinemas_sample.html'
      allow(FindAnyFilm).to receive(:find_cinemas).with('a postcode').and_return cinemas
      @cinemas = DataSource.find_cinemas('a postcode')
    end

    it 'should get all the cinemas' do
      expect(@cinemas.size).to eq 50
    end

    it 'should get the venue id' do
      expect(@cinemas[0].id).to eq '1574'
    end

    it 'should get the venue name' do
      expect(@cinemas[0].name).to eq 'Renoir'
    end
  end
end
