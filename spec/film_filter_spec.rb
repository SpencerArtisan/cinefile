require 'film_filter'

describe FilmFilter do
  let (:datasource) { double }
  let (:film) { double }
  let (:cinema) { double }
  let (:filter) { FilmFilter.new datasource }

  context '#get_films' do
    before do
      allow(datasource).to receive(:get_films).and_return [film]
    end

    it 'should include all films which are old' do
      expect(filter.get_films(cinema, 1)).to eq [film]
    end
  end

  context '#find_cinemas' do
    context 'when there are fewer than the max cinemas' do
      before do
        allow(datasource).to receive(:find_cinemas).and_return [cinema]
      end

      it 'should return all the cinemas' do
        expect(filter.find_cinemas('a postcode', 2)).to eq [cinema]
      end
    end

    context 'when there are exactly the max cinemas' do
      before do
        allow(datasource).to receive(:find_cinemas).and_return [cinema, cinema]
      end

      it 'should return all the cinemas' do
        expect(filter.find_cinemas('a postcode', 2)).to eq [cinema, cinema]
      end
    end

    context 'when there are more than the max cinemas' do
      before do
        allow(datasource).to receive(:find_cinemas).and_return [cinema, cinema, cinema]
      end

      it 'should return all the cinemas' do
        expect(filter.find_cinemas('a postcode', 2)).to eq [cinema, cinema]
      end
    end
  end
end
