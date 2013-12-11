require 'filter'

describe Filter do
  let (:datasource) { double }
  let (:film) { double }
  let (:cinema) { double }
  let (:filter) { Filter.new datasource }

  context '#get_films' do
    before do
      allow(datasource).to receive(:get_films).and_return [film]
    end

    it 'should include films which are old' do
      allow(film).to receive(:year).and_return 1979
      expect(filter.get_films(cinema, 1)).to eq [film]
    end

    it 'should exclude films which are new' do
      allow(film).to receive(:year).and_return 1980
      expect(filter.get_films(cinema, 1)).to eq []
    end
  end

  context '#find_cinemas' do
    context 'when there are fewer than 50 cinemas' do
      before do
        allow(datasource).to receive(:find_cinemas).and_return [cinema]
      end

      it 'should return all the cinemas' do
        expect(filter.find_cinemas('a postcode')).to eq [cinema]
      end
    end

    context 'when there are exactly 50 cinemas' do
      before do
        allow(datasource).to receive(:find_cinemas).and_return [cinema] * 50
      end

      it 'should return all the cinemas' do
        expect(filter.find_cinemas('a postcode')).to eq [cinema] * 50
      end
    end

    context 'when there are more than 50 cinemas' do
      before do
        allow(datasource).to receive(:find_cinemas).and_return [cinema] * 51
      end

      it 'should return all the cinemas' do
        expect(filter.find_cinemas('a postcode')).to eq [cinema] * 50
      end
    end
  end
end
