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
                    {id: 1, title: 'a film', day_on: '2001-12-25'}
                    {id: 2, title: 'another film', day_on: '2001-12-25'}
                ]
        )
        scope.loadFilms()
        httpBackend.flush()
        @film = scope.films[0]

      it "should provide all the films", ->
        expect(scope.films.length).toEqual(2)

      it "should provide the film title", ->
        expect(@film.title).toEqual("a film")

      it "should provide the film date", ->
        expect(@film.day_on).toEqual("2001-12-25")

      it "should provide a formatted date", ->
        expect(scope.when_formatted(@film.day_on)).toEqual("Tuesday 25 December")

  #describe "Selecting a film", ->
  #describe "Selecting a film", ->
    #it "should navigate to the film page", ->
      #spyOn(location, "path")
      #scope.showRace("id")
      #expect(location.path).toHaveBeenCalledWith("/races/id")
