// Generated by CoffeeScript 1.3.3
(function() {

  describe("FilmsController", function() {
    var httpBackend, location, resource, scope, subject;
    subject = void 0;
    scope = void 0;
    location = void 0;
    resource = void 0;
    httpBackend = void 0;
    beforeEach(module("app"));
    beforeEach(inject(function($rootScope, $location, $resource, $controller) {
      scope = $rootScope.$new();
      location = $location;
      resource = $resource;
      return subject = $controller("FilmsController", {
        $scope: scope
      });
    }));
    beforeEach(function() {
      return angular.mock.inject(function($injector) {
        return httpBackend = $injector.get("$httpBackend");
      });
    });
    return describe("Loading the films", function() {
      describe("which succeeds when retrieving from the server", function() {
        beforeEach(function() {
          httpBackend.expectGET("/films").respond(201, {
            films: [
              {
                id: 1,
                title: 'a film',
                showings: [
                  {
                    day_on: '2001-12-26'
                  }
                ]
              }
            ]
          });
          scope.loadFilms();
          httpBackend.flush();
          this.film = scope.films[0];
          return scope.film = scope.films[0];
        });
        it("should provide all the films", function() {
          return expect(scope.films.length).toEqual(1);
        });
        it("should provide the film title", function() {
          return expect(this.film.title).toEqual("a film");
        });
        it("should provide the film date", function() {
          return expect(this.film.showings[0].day_on).toEqual("2001-12-26");
        });
        it("should provide a formatted date", function() {
          return expect(scope.when_formatted(this.film.day_on)).toEqual("Wednesday 25 December");
        });
        it("should provide a list of dates for a specific film", function() {
          return expect(scope.filmDates()).toEqual(["2001-12-26"]);
        });
        it("should provide a list of showings for a specific film on a specific date", function() {
          return expect(scope.showingsOn("2001-12-26")[0].day_on).toEqual("2001-12-26");
        });
        return it("should provide an empty list of showings for a specific film on a specific date", function() {
          return expect(scope.showingsOn("2001-12-27").length).toEqual(0);
        });
      });
      describe("which retrieves multiple films with single showings", function() {
        beforeEach(function() {
          httpBackend.expectGET("/films").respond(201, {
            films: [
              {
                id: 1,
                title: 'a film',
                showings: [
                  {
                    day_on: '2001-12-26'
                  }
                ]
              }, {
                id: 2,
                title: 'another film',
                showings: [
                  {
                    day_on: '2001-12-25'
                  }
                ]
              }, {
                id: 2,
                title: 'a third film',
                showings: [
                  {
                    day_on: '2001-12-26'
                  }
                ]
              }
            ]
          });
          scope.loadFilms();
          return httpBackend.flush();
        });
        it("should provide a list of dates for all films", function() {
          return expect(scope.filmsDates()).toEqual(["2001-12-25", "2001-12-26"]);
        });
        it("should provide a list of dates for a specific film", function() {
          scope.film = scope.films[0];
          return expect(scope.filmDates()).toEqual(["2001-12-26"]);
        });
        return it("should get the films on a date", function() {
          expect(scope.filmsOn("2001-12-25")).toEqual([scope.films[1]]);
          return expect(scope.filmsOn("2001-12-26")).toEqual([scope.films[0], scope.films[2]]);
        });
      });
      return describe("which retrieves a single film with multiple showings", function() {
        beforeEach(function() {
          httpBackend.expectGET("/films").respond(201, {
            films: [
              {
                id: 1,
                title: 'a film',
                showings: [
                  {
                    day_on: '2001-12-26'
                  }, {
                    day_on: '2001-12-25'
                  }, {
                    day_on: '2001-12-26'
                  }
                ]
              }
            ]
          });
          scope.loadFilms();
          return httpBackend.flush();
        });
        it("should provide a list of dates for all films", function() {
          return expect(scope.filmsDates()).toEqual(["2001-12-25", "2001-12-26"]);
        });
        it("should provide a list of dates for a specific film", function() {
          scope.film = scope.films[0];
          return expect(scope.filmDates()).toEqual(["2001-12-25", "2001-12-26"]);
        });
        return it("should get the films on a date", function() {
          expect(scope.filmsOn("2001-12-25")).toEqual([scope.films[0]]);
          return expect(scope.filmsOn("2001-12-26")).toEqual([scope.films[0]]);
        });
      });
    });
  });

}).call(this);
