require 'venue'

class DataSource; end

describe Venue do
  it 'should retrieve the BFI southbank venue' do
    venues = Venue.all
    expect(venues[0].id).to eq 1522
  end

  it 'should find the films showing' do
    film = Film.new 'a film', 1979
    venue = Venue.new 1
    allow(DataSource).to receive(:get_films).with(1, 1).and_return [film]
    expect(venue.get_films(1)).to eq [film]
  end

  it 'should not retrieve modern films' do
    modern_film = Film.new 'a film', 1980
    venue = Venue.new 1
    allow(DataSource).to receive(:get_films).with(1, 1).and_return [modern_film]
    expect(venue.get_films(1)).to eq []
  end

  it 'should retrieve films for multiple dates' do
    film = Film.new 'a film', 1979
    another_film = Film.new 'another film', 1978
    venue = Venue.new 1
    allow(DataSource).to receive(:get_films).with(1, 1).and_return [film]
    allow(DataSource).to receive(:get_films).with(1, 2).and_return [another_film]
    expect(venue.get_films(2)).to eq [film, another_film]
  end
end
