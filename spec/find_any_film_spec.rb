require 'find_any_film'
require 'timecop'

describe FindAnyFilm do
  let (:datasource) { FindAnyFilm.new }

  context 'Reading the films for today' do
    let (:cinema) { Cinema.new '3471', 'a cinema' }

    before do
      Timecop.freeze 2013, 12, 25
      find_any_film_sample = File.read 'find_any_film_sample.json'
      allow(datasource).to receive(:read_films).with(cinema, 1).and_return find_any_film_sample
      @films = datasource.get_films(cinema, 1)
    end

    it 'should get all the films' do
      expect(@films.size).to eq 4
    end

    it 'should get the film title' do
      expect(@films[0].title).to eq 'Dope'
    end

    it 'should get the film year' do
      expect(@films[0].year).to eq 2015
    end

    it 'should get the film cinema' do
      expect(@films[0].showings[0].cinema).to equal cinema
    end

    it 'should get the film showing date' do
      expect(@films[0].showings[0].day_on).to eq Date.today
    end

    it 'should get the film showing times' do
      expect(@films[0].showings[0].times_on).to eq '18:20'
    end

    it 'should get all the showings' do
      expect(@films[0].showings.size).to eq(1)
    end
  end

  context 'Reading the films for tomorrow' do
    let (:cinema) { Cinema.new '3471', 'a cinema' }

    before do
      find_any_film_sample = File.read 'find_any_film_sample.json'
      allow(datasource).to receive(:read_films).with(cinema, 2).and_return find_any_film_sample
      @films = datasource.get_films(cinema, 2)
    end

    it 'should get the film showing date' do
      expect(@films[0].showings[0].day_on).to eq(Date.today + 1)
    end
  end

  context 'Reading the cinemas' do
    before do
      cinemas = File.read 'cinemas_sample.html'
      allow(datasource).to receive(:read_cinemas).with('a postcode').and_return cinemas
      @cinemas = datasource.find_cinemas('a postcode')
    end

    it 'should get all the cinemas' do
      expect(@cinemas.size).to eq 162
    end

    it 'should get the cinema id' do
      expect(@cinemas[0].id).to eq '3471'
    end

    it 'should get the cinema name' do
      expect(@cinemas[0].name).to eq 'BFI Southbank'
    end

    it 'should get the cinema postcode' do
      expect(@cinemas[0].postcode).to eq 'dummy'
    end
  end
end
