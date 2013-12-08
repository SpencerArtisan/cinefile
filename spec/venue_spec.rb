require 'venue'

describe Venue do
  it 'should retrieve the BFI southbank venue' do
    venues = Venue.all
    expect(venues[0].id).to eq 3471
  end
end
