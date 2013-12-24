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
      return describe("which succeeds when retrieving from the server", function() {
        beforeEach(function() {
          httpBackend.expectGET("/films").respond(201, {
            films: [
              {
                id: 1,
                title: 'a film',
                day_on: '2001-12-25'
              }, {
                id: 2,
                title: 'another film',
                day_on: '2001-12-25'
              }
            ]
          });
          scope.loadFilms();
          httpBackend.flush();
          return this.film = scope.films[0];
        });
        it("should provide all the films", function() {
          return expect(scope.films.length).toEqual(2);
        });
        it("should provide the film title", function() {
          return expect(this.film.title).toEqual("a film");
        });
        it("should provide the film date", function() {
          return expect(this.film.day_on).toEqual("2001-12-25");
        });
        return it("should provide a formatted date", function() {
          return expect(scope.when_formatted(this.film.day_on)).toEqual("Tuesday 25 December");
        });
      });
    });
  });

}).call(this);
