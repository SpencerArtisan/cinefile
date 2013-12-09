require 'film'
require 'timecop'

class Venue; end
  
describe Film do
  let (:venue) { double }
  let (:film) { Film.new 'a film', 1979, venue, Date.new(2001, 12, 25) }

  before do
    allow(venue).to receive(:name).and_return 'A cinema'
    allow(venue).to receive(:get_films).with(1).and_return [film]
    allow(Venue).to receive(:all).and_return [venue]
  end

  it 'should retrieve films from all venues' do
    expect(Film.all(1)).to eq [film]
  end

  it 'should convert film lists to json' do
    allow(film).to receive(:to_json).and_return 'film json'
    expect(Film.all(1).to_json).to eq('{"films":["film json"]}')
  end

  it 'should convert a single film to json' do
    expect(film.to_json).to eq('{"title":"a film","year":1979,"cinema":"A cinema","when":"2001-12-25"}')
  end
end
