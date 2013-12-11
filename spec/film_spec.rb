require 'film'
require 'timecop'

describe Film do
  let (:datasource) { double }
  let (:cinema) { double }
  let (:film) { Film.new 'a film', 1979, cinema, Date.new(2001, 12, 25) }

  before do
    allow(cinema).to receive(:name).and_return 'A cinema'
    allow(cinema).to receive(:get_films).with(datasource, 1).and_return [film]
    allow(Cinema).to receive(:all).and_return [cinema]
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
end
