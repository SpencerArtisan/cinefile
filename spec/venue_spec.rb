require 'venue'

class DataSource; end

describe Venue do
  let(:venue) { Venue.new 1, 'a cinema' }

  it 'should retrieve the BFI southbank venue' do
    allow(DataSource).to receive(:find_cinemas).with('WC1N').and_return [venue]
    venues = Venue.all
    expect(venues[0]).to equal(venue)
  end

  it 'should find the films showing' do
    film = Film.new 'a film', 1979
    allow(DataSource).to receive(:get_films).with(venue, 1).and_return [film]
    expect(venue.get_films(1)).to eq [film]
  end

  it 'should not retrieve modern films' do
    modern_film = Film.new 'a film', 1980
    allow(DataSource).to receive(:get_films).with(venue, 1).and_return [modern_film]
    expect(venue.get_films(1)).to eq []
  end

  it 'should retrieve films for multiple dates' do
    film = Film.new 'a film', 1979
    another_film = Film.new 'another film', 1978
    allow(DataSource).to receive(:get_films).with(venue, 1).and_return [film]
    allow(DataSource).to receive(:get_films).with(venue, 2).and_return [another_film]
    expect(venue.get_films(2)).to eq [film, another_film]
  end

  it 'should convert to and from json' do
    expect(Marshal::load(Marshal::dump(venue))).to eq venue
  end
end
