require 'venue'

class DataSource; end

describe Venue do
  it 'should retrieve the BFI southbank venue' do
    venues = Venue.all
    expect(venues[0].id).to eq 3471
  end

  it 'should find the films showing' do
    film = double
    venue = Venue.new 1
    allow(DataSource).to receive(:get_films).with(1).and_return [film]
    expect(venue.films).to eq [film]
  end
end
