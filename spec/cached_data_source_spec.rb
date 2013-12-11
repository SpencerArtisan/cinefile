require 'test_environment'
require 'cached_data_source'

describe CachedDataSource do
  let (:cinema) { Cinema.new 1, 'a cinema' }
  let (:data_source) { double }
  let (:cache) { CachedDataSource.new data_source }

  context "Cinema cache" do
    context 'When first called' do
      before do
        cache.clear
        allow(data_source).to receive(:find_cinemas).with('a postcode').and_return [cinema]
      end

      it 'should retrieve from the data source' do
        expect(cache.find_cinemas('a postcode')).to eq [cinema]
      end
    end

    context 'When subsequently called' do
      before do
        allow(data_source).to receive(:find_cinemas).with('a postcode').and_return [cinema]
        cache.find_cinemas 'a postcode'
        allow(data_source).to receive(:find_cinemas).with('a postcode').and_return []
      end

      it 'should retrieve the data from the cache' do
        expect(cache.find_cinemas('a postcode')).to eq [cinema]
      end

      it 'should retrieve from the data source if the postcode differs' do
        another_cinema = Cinema.new 2, 'another cinema'
        allow(data_source).to receive(:find_cinemas).with('another postcode').and_return [another_cinema]
        expect(cache.find_cinemas('another postcode')).to eq [another_cinema]
      end
    end
  end

  context "Film cache" do
    let (:cinema) { Cinema.new 1, 'a cinema' }
    let (:film) { Film.new 'a film', 1979, cinema, Date.new(2001, 12, 25) }

    context 'When first called' do
      before do
        cache.clear
        allow(data_source).to receive(:get_films).with(cinema, 1).and_return [film]
      end

      it 'should retrieve from the data source' do
        expect(cache.get_films(cinema, 1)).to eq [film]
      end
    end

    context 'When subsequently called' do
      before do
        allow(data_source).to receive(:get_films).with(cinema, 1).and_return [film]
        cache.get_films cinema, 1
        allow(data_source).to receive(:get_films).with(cinema, 1).and_return []
      end

      it 'should retrieve the data from the cache' do
        expect(cache.get_films(cinema, 1)).to eq [film]
      end

      it 'should retrieve from the data source if the day differs' do
        another_film = Film.new 'a film', 1979, cinema, Date.new(2001, 12, 25)
        allow(data_source).to receive(:get_films).with(cinema, 2).and_return [another_film]
        expect(cache.get_films(cinema, 2)).to eq [another_film]
      end

      it 'should retrieve from the data source if the cinema differs' do
        another_cinema = Cinema.new 2, 'another cinema'
        another_film = Film.new 'a film', 1979, another_cinema, Date.new(2001, 12, 25)
        allow(data_source).to receive(:get_films).with(another_cinema, 2).and_return [another_film]
        expect(cache.get_films(another_cinema, 2)).to eq [another_film]
      end
    end
  end
end
