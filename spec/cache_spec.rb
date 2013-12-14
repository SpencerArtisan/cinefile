require 'test_environment'
require 'cache'
require 'film'

describe Cache do
  let (:cinema) { Cinema.new 1, 'a cinema' }
  let (:finder) { double }
  let (:cache) { Cache.new finder }

  let (:cinema) { Cinema.new 1, 'a cinema' }
  let (:film) { Film.new 'a film', 1979, cinema, Date.new(2001, 12, 25), 'some times' }

  context 'When first called' do
    before do
      cache.clear
      allow(finder).to receive(:get_films).with('a postcode', 7).and_return [film]
    end

    it 'should retrieve from the data source' do
      expect(cache.get_films('a postcode', 7)).to eq [film]
    end

    it 'should convert film lists to json' do
      expect(cache.get_films('a postcode', 7).to_json).to eq '{"films":[{"title":"a film","year":1979,"link":null,"showings":[{"cinema":"a cinema","day_on":"2001-12-25","times_on":"some times"}]}]}'
    end
  end

  context 'When subsequently called' do
    before do
      cache.clear
      allow(finder).to receive(:get_films).with('a postcode', 7).and_return [film]
      cache.get_films 'a postcode', 7
      allow(finder).to receive(:get_films).with('a postcode', 7).and_return []
    end

    it 'should retrieve the data from the cache' do
      expect(cache.get_films('a postcode', 7)[0].to_json).to eq film.to_json
    end

    it 'should convert film lists to json' do
      expect(cache.get_films('a postcode', 7).to_json).to eq '{"films":[{"title":"a film","year":1979,"link":null,"showings":[{"cinema":"a cinema","day_on":"2001-12-25","times_on":"some times"}]}]}'
    end
  end
end
