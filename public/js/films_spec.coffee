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
                    {id: 1, title: 'a film'}
                    {id: 2, title: 'another film'}
                ]
        )
        scope.loadFilms()
        httpBackend.flush()
        @film = scope.films[0]

      it "should provide all the films", ->
        expect(scope.films.length).toEqual(2)

      #it "should provide the track name", ->
        #expect(@race.track_name).toEqual("a track")

      #it "should provide the race number", ->
        #expect(@race.race_number).toEqual(1)
          
      #it "should provide the time of the race", ->
        #expect(scope.race_short_time(@race)).toEqual("4:50 PM")

      #it "should provide the time left before the race", ->
        #TimeUtils.freezeTime("2013-10-26T16:00:00Z")
        #expect(scope.time_until_start(@race)).toEqual("50:00")

      #it "should consider the race to be starting soon if there are less than 10 minutes to go", ->
        #TimeUtils.freezeTime("2013-10-26T16:40:01Z")
        #expect(scope.race_starts_soon(@race)).toBeTruthy()

      #it "should consider the race not to be starting soon if there are 10 minutes or more to go", ->
        #TimeUtils.freezeTime("2013-10-26T16:40:00")
        #expect(scope.race_starts_soon(@race)).toBeFalsy()

  #describe "Selecting a race", ->
    #it "should navigate to the race page", ->
      #spyOn(location, "path")
      #scope.showRace("id")
      #expect(location.path).toHaveBeenCalledWith("/races/id")

