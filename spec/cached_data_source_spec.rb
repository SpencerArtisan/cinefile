require 'cached_data_source'

describe CachedDataSource do
  let (:cinema) { Venue.new 1, 'a cinema' }
  let (:data_source) { double }
  let (:cache) { CachedDataSource.new data_source }

  before do
  end

  context 'When the cinema cache is first called' do
    before do
      cache.clear
      allow(data_source).to receive(:find_cinemas).with('a postcode').and_return [cinema]
    end

    it 'should retrieve from the data source' do
      expect(cache.find_cinemas('a postcode')).to eq [cinema]
    end
  end

  context 'When the cinema cache is subsequently called' do
    before do
      allow(data_source).to receive(:find_cinemas).with('a postcode').and_return [cinema]
      cache.find_cinemas 'a postcode'
      allow(data_source).to receive(:find_cinemas).with('a postcode').and_return []
    end

    it 'should retrieve the data from the cache' do
      expect(cache.find_cinemas('a postcode')).to eq [cinema]
    end

    it 'should retrieve from the data source if the postcode differs' do
      another_cinema = Venue.new 2, 'another cinema'
      allow(data_source).to receive(:find_cinemas).with('another postcode').and_return [another_cinema]
      expect(cache.find_cinemas('another postcode')).to eq [another_cinema]
    end
  end
end
