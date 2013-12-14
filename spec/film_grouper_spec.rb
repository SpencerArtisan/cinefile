require 'film_grouper'

describe FilmGrouper do
  let (:datasource) { double }
  let (:grouper) { FilmGrouper.new datasource }
  let(:cinema1) { double name: 'a cinema' }
  let(:cinema2) { double name: 'another cinema' }

  context 'multiple cinemas' do
    let (:film1) { Film.new 'a film', 1979, cinema1, Date.new(2001, 12, 25), 'some times' }
    let (:film2) { Film.new 'another film', 1979, cinema2, Date.new(2001, 12, 25), 'some times' }

    before do
      allow(datasource).to receive(:find_cinemas).with('a postcode').and_return [cinema1, cinema2] 
      allow(datasource).to receive(:get_films).with(cinema1, 1).and_return [film1]
      allow(datasource).to receive(:get_films).with(cinema2, 1).and_return [film2]
      @films = grouper.get_films 'a postcode', 1
    end

    it 'should retrieve films from all cinemas' do
      expect(@films).to eq [film1, film2]
    end

  end

  context 'films with matching titles' do
    let (:film1) { Film.new 'a film', 1979, cinema1, Date.new(2001, 12, 26), 'some times' }
    let (:film2) { Film.new 'a film', 1979, cinema1, Date.new(2001, 12, 25), 'some times' }

    before do
      allow(datasource).to receive(:find_cinemas).with('a postcode').and_return [cinema1] 
      allow(datasource).to receive(:get_films).with(cinema1, 1).and_return [film1, film2]
      @films = grouper.get_films 'a postcode', 1
    end

    it 'should be grouped into one film' do
      expect(@films).to have(1).item
    end

    it 'should have all their showings' do
      expect(@films[0]).to have(2).showings
    end

    it 'should order showings by date' do
      expect(@films[0].showings[0].day_on).to eq Date.new(2001, 12, 25)
      expect(@films[0].showings[1].day_on).to eq Date.new(2001, 12, 26)
    end
  end
end
