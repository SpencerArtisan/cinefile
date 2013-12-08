require 'film'

class Venue; end
  
describe Film do
  let (:venue) { double }
  let (:film) { double }

  it 'should retrieve films from all venues' do
    allow(venue).to receive(:films).and_return [film]
    allow(Venue).to receive(:all).and_return [venue]
    expect(Film.all).to eq [film]
  end
end
