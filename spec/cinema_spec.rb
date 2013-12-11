require 'cinema'

class DataSource; end

describe Cinema do
  let(:cinema) { Cinema.new 1, 'a cinema' }
  let(:datasource) { double }

  it 'should retrieve the BFI southbank cinema' do
    allow(datasource).to receive(:find_cinemas).with('WC1N').and_return [cinema]
    cinemas = Cinema.all(datasource)
    expect(cinemas[0]).to equal(cinema)
  end

  it 'should find the films showing' do
    film = Film.new 'a film', 1979
    allow(datasource).to receive(:get_films).with(cinema, 1).and_return [film]
    expect(cinema.get_films(datasource, 1)).to eq [film]
  end

  it 'should retrieve films for multiple dates' do
    film = Film.new 'a film', 1979
    another_film = Film.new 'another film', 1978
    allow(datasource).to receive(:get_films).with(cinema, 1).and_return [film]
    allow(datasource).to receive(:get_films).with(cinema, 2).and_return [another_film]
    expect(cinema.get_films(datasource, 2)).to eq [film, another_film]
  end

  it 'should convert to and from json' do
    expect(Marshal::load(Marshal::dump(cinema))).to eq cinema
  end
end
