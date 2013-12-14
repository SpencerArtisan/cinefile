require 'rotten_tomatoes'

describe RottenTomatoes do
  let (:film) { double }
  let (:rotten_tomatoes) { RottenTomatoes.new }


  it 'should not fail if it does not find the film' do
    allow(film).to receive(:title).and_return 'wehjkh fjefhjfhjewfhfjjhehrjhhh jfhe'
    details = rotten_tomatoes.get_details film
    expect(details.link).to be_nil
  end

  it 'should find the film' do
    allow(film).to receive(:title).and_return 'Gone With The Wind (1939)'
    details = rotten_tomatoes.get_details film
    expect(details.link).to eq 'http://www.rottentomatoes.com/m/gone_with_the_wind/'
  end
end
