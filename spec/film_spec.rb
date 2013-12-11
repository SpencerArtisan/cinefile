require 'film'
require 'timecop'

describe Film do
  let (:datasource) { double }
  let (:cinema) { double }

  context 'single films' do
    let (:film) { Film.new 'a film', 1979, cinema, Date.new(2001, 12, 25) }

    before do
      allow(Cinema).to receive(:all).and_return [cinema]
      allow(cinema).to receive(:name).and_return 'A cinema'
      allow(cinema).to receive(:get_films).with(datasource, 1).and_return [film]
    end

    it 'should retrieve films from all cinemas' do
      expect(Film.all(datasource, 1)).to eq [film]
    end

    it 'should convert film lists to json' do
      expect(Film.all(datasource, 1).to_json).to eq '{"films":[{"title":"a film","year":1979,"cinema":"A cinema","when":"2001-12-25"}]}'
    end

    it 'should convert a single film to json' do
      expect(film.to_json).to eq('{"title":"a film","year":1979,"cinema":"A cinema","when":"2001-12-25"}')
    end

    it 'should format the showing date' do
      expect(film.when_formatted).to eq 'Tue 25 Dec'
    end
  end

  context 'multiple films' do
    let (:film1) { Film.new 'a film', 1979, cinema, Date.new(2001, 12, 25) }
    let (:film2) { Film.new 'a film', 1979, cinema, Date.new(2001, 12, 26) }

    before do
      allow(Cinema).to receive(:all).and_return [cinema]
      allow(cinema).to receive(:name).and_return 'A cinema'
      allow(cinema).to receive(:get_films).with(datasource, 1).and_return [film1, film2]
    end

    it 'should group showings on different dates' do
      expect(Film.all(datasource, 1)).to have(1).item
    end
  end
end
