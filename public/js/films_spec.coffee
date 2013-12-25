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

  describe "Loading the films", ->
    describe "which succeeds when retrieving from the server", ->
      beforeEach ->
        httpBackend.expectGET("/films").respond(201, 
            films: 
                [
                    {id: 1, title: 'a film', showings:[{day_on: '2001-12-26'}]}
                ]
        )
        scope.loadFilms()
        httpBackend.flush()
        @film = scope.films[0]
        scope.film = scope.films[0]

      it "should provide all the films", ->
        expect(scope.films.length).toEqual(1)

      it "should provide the film title", ->
        expect(@film.title).toEqual("a film")

      it "should provide the film date", ->
        expect(@film.showings[0].day_on).toEqual("2001-12-26")

      it "should provide a formatted date", ->
        expect(scope.when_formatted(@film.day_on)).toEqual("Wednesday 25 December")

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
                    {id: 1, title: 'a film', showings:[{day_on: '2001-12-26'}]}
                    {id: 2, title: 'another film', showings:[{day_on: '2001-12-25'}]}
                    {id: 2, title: 'a third film', showings:[{day_on: '2001-12-26'}]}
                ]
        )
        scope.loadFilms()
        httpBackend.flush()

      it "should provide a list of dates for all films", ->
        expect(scope.filmsDates()).toEqual(["2001-12-25", "2001-12-26"])

      it "should provide a list of dates for a specific film", ->
        scope.film = scope.films[0]
        expect(scope.filmDates()).toEqual(["2001-12-26"])

      it "should get the films on a date", ->
        expect(scope.filmsOn("2001-12-25")).toEqual([scope.films[1]])
        expect(scope.filmsOn("2001-12-26")).toEqual([scope.films[0], scope.films[2]])

    describe "which retrieves a single film with multiple showings", ->
      beforeEach ->
        httpBackend.expectGET("/films").respond(201, 
            films: 
                [
                    {id: 1, title: 'a film', showings:
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

      it "should provide a list of dates for all films", ->
        expect(scope.filmsDates()).toEqual(["2001-12-25", "2001-12-26"])

      it "should provide a list of dates for a specific film", ->
        scope.film = scope.films[0]
        expect(scope.filmDates()).toEqual(["2001-12-25", "2001-12-26"])

      it "should get the films on a date", ->
        expect(scope.filmsOn("2001-12-25")).toEqual([scope.films[0]])
        expect(scope.filmsOn("2001-12-26")).toEqual([scope.films[0]])

