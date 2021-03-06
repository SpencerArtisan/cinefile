require 'film_augmenter'

describe FilmAugmenter do
  let (:cinema) { double }
  let (:data_source) { double }
  let (:film) { Film.new 'a film', 1979, cinema, Date.new(2001, 12, 25), 'a time' }
  let (:rotten_movie) { double.as_null_object }
  let (:augmenter) { FilmAugmenter.new data_source }

  context 'Multiple films' do
    let (:film2) { Film.new 'a film', 1979, cinema, Date.new(2001, 12, 25), 'a time' }

    before do
      allow(data_source).to receive(:get_films).and_return [film, film2]
      allow(RottenMovie).to receive(:find).and_return []
    end
  end

  context 'One film' do
    before do
      allow(data_source).to receive(:get_films).and_return [film] 
    end

    context 'When rotten tomatoes throws an error' do
      before do
        allow(RottenMovie).to receive(:find).and_raise Exception.new
      end

      it 'should continue' do
        films = augmenter.get_films 'a postcode', 7, 42
        expect(films).to eq [film]
      end
    end

    context 'When rotten tomatoes matches with no movies' do
      before do
        allow(RottenMovie).to receive(:find).and_return nil
        @films = augmenter.get_films 'a postcode', 7, 42
      end

      it 'should return the same films as the datasource' do
        expect(@films).to eq [film]
      end

      it 'should leave the rating as nil' do
        expect(@films[0].rating).to be_nil
      end

      it 'should leave the language as nil' do
        expect(@films[0].language).to be_nil
      end
    end

    context 'When rotten tomatoes matches with one movie' do
      before do
        allow(RottenMovie).to receive(:find).and_return rotten_movie
        allow(rotten_movie).to receive(:release_dates).and_return double(theater: '1979-12-25')
      end

      it 'should return the same films as the datasource' do
        films = augmenter.get_films 'a postcode', 7, 42
        expect(films).to eq [film]
      end

      it 'should add an image for the film' do
        allow(rotten_movie).to receive(:posters).and_return double(original: 'an image link')
        augmenter.get_films 'a postcode', 7, 42
        expect(film.image).to eq 'an image link'
      end

      it 'should add a review for the film' do
        allow(rotten_movie).to receive(:critics_consensus).and_return 'a review'
        augmenter.get_films 'a postcode', 7, 42
        expect(film.review).to eq 'a review'
      end

      it 'should add a language for the film' do
        #allow(rotten_movie).to receive(:synopsis).and_return 'a synopsis'
        augmenter.get_films 'a postcode', 7, 42
        expect(film.language).to eq 'EN'
      end

      context 'The theater release year is way out' do
        before do
          allow(rotten_movie).to receive(:release_dates).and_return double(theater: '2013-12-25')
        end

        it 'should not augment the film' do
          augmenter.get_films 'a postcode', 7, 42
          expect(film.rating).to be_nil
        end

        context 'The year is roughly right' do
          before do
            allow(rotten_movie).to receive(:year).and_return 1980
          end

          it 'should augment the film' do
            augmenter.get_films 'a postcode', 7, 42
            expect(film.rating).not_to be_nil
          end
        end
      end

      context 'A critics rating is available' do
        before do
          allow(rotten_movie).to receive(:ratings).and_return double(critics_score: 96)
        end

        it 'should use the critics rating' do
          augmenter.get_films 'a postcode', 7, 42
          expect(film.rating).to eq 96
        end
      end

      context 'A critics rating is not available' do
        before do
          allow(rotten_movie).to receive(:ratings).and_return double(critics_score: nil, audience_score: 96)
        end

        it 'should use the audience rating' do
          augmenter.get_films 'a postcode', 7, 42
          expect(film.rating).to eq 96
        end
      end

      context 'The critics rating is -1' do
        before do
          allow(rotten_movie).to receive(:ratings).and_return double(critics_score: -1, audience_score: 96)
        end

        it 'should use the audience rating' do
          augmenter.get_films 'a postcode', 7, 42
          expect(film.rating).to eq 96
        end
      end

      context 'The critics and audience ratings are -1' do
        before do
          allow(rotten_movie).to receive(:ratings).and_return double(critics_score: -1, audience_score: -1)
        end

        it 'should have a nil rating' do
          augmenter.get_films 'a postcode', 7, 42
          expect(film.rating).to be_nil
        end
      end
    end

    context 'When rotten tomatoes matches with multiple movies' do
      let (:right_movie) { double.as_null_object }
      let (:wrong_movie) { double.as_null_object }

      context 'With different years' do
        before do
          allow(right_movie).to receive(:release_dates).and_return double(theater: '1944-12-25')
          allow(wrong_movie).to receive(:release_dates).and_return double(theater: '2013-12-25')
          film.title = "Gaslight (1944)"
          film.year = 1944
          allow(RottenMovie).to receive(:find).and_return [wrong_movie, right_movie]
        end

        it 'should return the same films as the datasource' do
          films = augmenter.get_films 'a postcode', 7, 42
          expect(films).to eq [film]
        end

        it 'should pick the movie by year' do
          allow(right_movie).to receive(:critics_consensus).and_return 'right review'
          augmenter.get_films 'a postcode', 7, 42
          expect(film.review).to eq 'right review'
        end
      end

      context 'With identical years' do
        before do
          allow(right_movie).to receive(:release_dates).and_return double(theater: '1944-12-25')
          allow(wrong_movie).to receive(:release_dates).and_return double(theater: '1944-12-25')
          film.title = "Gaslight (1944)"
          film.year = 1944
          allow(RottenMovie).to receive(:find).and_return [right_movie, wrong_movie]
        end

        it 'should return the same films as the datasource' do
          films = augmenter.get_films 'a postcode', 7, 42
          expect(films).to eq [film]
        end

        it 'should pick the first movie returned by rottentomatoes' do
          allow(right_movie).to receive(:critics_consensus).and_return 'right review'
          augmenter.get_films 'a postcode', 7, 42
          expect(film.review).to eq 'right review'
        end
      end

      context 'With the years way out' do
        before do
          allow(right_movie).to receive(:release_dates).and_return double(theater: '2013-12-25')
          allow(wrong_movie).to receive(:release_dates).and_return double(theater: '2013-12-25')
          allow(RottenMovie).to receive(:find).and_return [right_movie, wrong_movie]
        end

        it 'should not augment the film' do
          augmenter.get_films 'a postcode', 7, 42
          expect(film.review).to be_nil
        end
      end
    end
  end
end
