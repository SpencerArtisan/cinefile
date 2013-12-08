require 'data_source'

class FindAnyFilm; end

describe DataSource do
  it 'should get the films from findanyfilm.com' do
    find_any_film_sample = File.read 'find_any_film_sample.json'
    allow(FindAnyFilm).to receive(:get_films).with(1, 1).and_return find_any_film_sample
    films = DataSource.get_films(1, 1)
    expect(films.size).to eq 6
    expect(films[0].title).to eq 'Gone With The Wind (1939) (PG)'
    expect(films[0].year).to eq 1939
  end
end
