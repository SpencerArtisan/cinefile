describe "FilmsController", ->
  subject = undefined
  scope = undefined
  location = undefined
  resource = undefined
  httpBackend = undefined

  beforeEach(module("app"))
  beforeEach inject(($rootScope, $location, $resource, $controller) ->
    scope = $rootScope.$new()
    location = $location
    resource = $resource
    subject = $controller("FilmsController",
      $scope: scope
    )
  )
  beforeEach ->
    angular.mock.inject(($injector) ->
      httpBackend = $injector.get("$httpBackend")
    )

  describe "Categories", ->
    it "should have an initial category of All Movies", ->
      expect(scope.category()).toEqual("All Movies")

    it "should be able to go to the previous category", ->
      scope.previousCategory()
      expect(scope.category()).toEqual("Latest Releases")

    it "should be able to cycle round the categories backwards", ->
      scope.previousCategory()
      scope.previousCategory()
      scope.previousCategory()
      expect(scope.category()).toEqual("All Movies")

    it "should be able to cycle round the categories forwards", ->
      scope.nextCategory()
      scope.nextCategory()
      scope.nextCategory()
      expect(scope.category()).toEqual("All Movies")

    it "should be able to go to the next category", ->
      scope.nextCategory()
      expect(scope.category()).toEqual("Classic Movies")

    describe "Filtering", ->
      beforeEach ->
        httpBackend.expectGET("/films").respond(201, 
            films: 
                [
                    {title: 'a film (1939)', showings:[{day_on: '2001-12-26'}]}
                ]
        )
        scope.loadFilms()
        httpBackend.flush()

      it "shouldn't filter with the All category", ->
        scope.categoryIndex = 0
        expect(scope.allFilms()).toEqual(scope.films)

      it "should filter Classic Movies to include films before 1980", ->
        scope.categoryIndex = 1
        scope.films[0].year = 1979
        expect(scope.allFilms()).toEqual(scope.films)

      it "should filter Classic Movies to exclude films after 1980", ->
        scope.categoryIndex = 1
        scope.films[0].year = 1980
        expect(scope.allFilms()).toEqual([])

      it "should filter Latest Releases to include films made this year", ->
        scope.categoryIndex = 2
        scope.films[0].year = new Date().getFullYear()
        expect(scope.allFilms()).toEqual(scope.films)

      it "should filter Latest Releases to include films made last year", ->
        scope.categoryIndex = 2
        scope.films[0].year = new Date().getFullYear() - 1
        expect(scope.allFilms()).toEqual(scope.films)

      it "should filter Latest Releases to exclude films made two years ago", ->
        scope.categoryIndex = 2
        scope.films[0].year = new Date().getFullYear() - 2
        expect(scope.allFilms()).toEqual([])


  describe "Loading the films", ->
    describe "which has not yet returned data from the server", ->
      it "should provide a blank film title", ->
        expect(scope.short_title(scope.film)).toEqual("")

      it "should provide an empty list of film dates", ->
        expect(scope.filmDates()).toEqual([])

      it "should identify this as not a great film", ->
        expect(scope.great(scope.film)).toBeFalsy()

    describe "which succeeds when retrieving from the server", ->
      beforeEach ->
        httpBackend.expectGET("/films").respond(201, 
            films: 
                [
                    {title: 'a film (1939)', showings:[{day_on: '2001-12-26'}]}
                ]
        )
        scope.loadFilms()
        httpBackend.flush()
        @film = scope.films[0]
        scope.film = scope.films[0]

      it "should identify if this is a great film", ->
        @film.rating = 92
        expect(scope.great(@film)).toBeTruthy()

      it "should identify if this is not a great film", ->
        @film.rating = 91
        expect(scope.great(@film)).toBeFalsy()

      it "should provide all the films", ->
        expect(scope.films.length).toEqual(1)

      it "should provide the film title", ->
        expect(@film.title).toEqual("a film (1939)")

      it "should provide the film title without the year", ->
        expect(scope.short_title(@film)).toEqual("a film")

      it "should provide the film date", ->
        expect(@film.showings[0].day_on).toEqual("2001-12-26")

      it "should provide a formatted date", ->
        expect(scope.when_formatted(@film.showings[0].day_on)).toEqual("Wednesday 26 December")

      it "should provide a list of dates for a specific film", ->
        expect(scope.filmDates()).toEqual(["2001-12-26"])

      it "should provide a list of showings for a specific film on a specific date", ->
        expect(scope.showingsOn("2001-12-26")[0].day_on).toEqual("2001-12-26")

      it "should provide an empty list of showings for a specific film on a specific date", ->
        expect(scope.showingsOn("2001-12-27").length).toEqual(0)

    describe "which retrieves multiple films with single showings", ->
      beforeEach ->
        httpBackend.expectGET("/films").respond(201, 
            films: 
                [
                    {title: 'a film', rating: 42, showings:[{day_on: '2001-12-26'}]}
                    {title: 'another film', rating: 82, showings:[{day_on: '2001-12-25'}]}
                    {title: 'a third film', rating: 96, showings:[{day_on: '2001-12-26'}]}
                ]
        )
        scope.loadFilms()
        httpBackend.flush()

      it "should provide a list of all films", ->
        expect(scope.allFilms()).toEqual(scope.films)

      it "should provide a list of all great films", ->
        scope.filterGreatMovies()
        expect(scope.allFilms()).toEqual([scope.films[2]])

      it "should provide a list of dates for all films", ->
        expect(scope.filmsDates()).toEqual(["2001-12-25", "2001-12-26"])

      it "should provide a list of dates for all great films", ->
        scope.filterGreatMovies()
        expect(scope.filmsDates()).toEqual(["2001-12-26"])

      it "should toggle the filter", ->
        scope.filterGreatMovies()
        scope.filterGreatMovies()
        expect(scope.allFilms()).toEqual(scope.films)

      it "should provide a list of dates for a specific film", ->
        scope.film = scope.films[0]
        expect(scope.filmDates()).toEqual(["2001-12-26"])

      it "should get the films on a date", ->
        expect(scope.filmsOn("2001-12-25")).toEqual([scope.films[1]])
        expect(scope.filmsOn("2001-12-26")).toEqual([scope.films[0], scope.films[2]])

      it "should get the great films on a date", ->
        scope.filterGreatMovies()
        expect(scope.filmsOn("2001-12-25")).toEqual([])
        expect(scope.filmsOn("2001-12-26")).toEqual([scope.films[2]])

    describe "which retrieves a single film with multiple showings", ->
      beforeEach ->
        httpBackend.expectGET("/films").respond(201, 
            films: 
                [
                    {title: 'a film', showings:
                        [
                            {day_on: '2001-12-26'}
                            {day_on: '2001-12-25'}
                            {day_on: '2001-12-26'}
                        ]
                    }
                ]
        )
        scope.loadFilms()
        httpBackend.flush()

      it "should assign ids to the showings", ->
        showings = scope.films[0].showings
        expect(showings[0].id).toEqual(0)
        expect(showings[1].id).toEqual(1)
        expect(showings[2].id).toEqual(2)

      it "should provide a list of dates for all films", ->
        expect(scope.filmsDates()).toEqual(["2001-12-25", "2001-12-26"])

      it "should provide a list of dates for a specific film", ->
        scope.film = scope.films[0]
        expect(scope.filmDates()).toEqual(["2001-12-25", "2001-12-26"])

      it "should get the films on a date", ->
        expect(scope.filmsOn("2001-12-25")).toEqual([scope.films[0]])
        expect(scope.filmsOn("2001-12-26")).toEqual([scope.films[0]])

