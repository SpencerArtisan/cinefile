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
    describe("By Date", function() {
      it("should initially show by film", function() {
        return expect(scope.byDate).toBeFalsy();
      });
      it("should be able to go to by date mode", function() {
        scope.toggleMode();
        return expect(scope.byDate).toBeTruthy();
      });
      return it("should rotate from by date back to by film", function() {
        scope.toggleMode();
        scope.toggleMode();
        return expect(scope.byDate).toBeFalsy();
      });
    });
    describe("Categories", function() {
      it("should have an initial category of All Movies", function() {
        return expect(scope.category()).toEqual("All Movies");
      });
      it("should be able to go to the previous category", function() {
        scope.previousCategory();
        return expect(scope.category()).toEqual("Latest Releases");
      });
      it("should be able to cycle round the categories backwards", function() {
        scope.previousCategory();
        scope.previousCategory();
        scope.previousCategory();
        return expect(scope.category()).toEqual("All Movies");
      });
      it("should be able to cycle round the categories forwards", function() {
        scope.nextCategory();
        scope.nextCategory();
        scope.nextCategory();
        return expect(scope.category()).toEqual("All Movies");
      });
      it("should be able to go to the next category", function() {
        scope.nextCategory();
        return expect(scope.category()).toEqual("Classic Movies");
      });
      return describe("Filtering", function() {
        beforeEach(function() {
          httpBackend.expectGET("/films").respond(201, {
            films: [
              {
                title: 'a film (1939)',
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
        it("shouldn't filter with the All category", function() {
          scope.categoryIndex = 0;
          return expect(scope.allFilms()).toEqual(scope.films);
        });
        it("should filter Classic Movies to include films before 1980", function() {
          scope.categoryIndex = 1;
          scope.films[0].year = 1979;
          return expect(scope.allFilms()).toEqual(scope.films);
        });
        it("should filter Classic Movies to exclude films after 1980", function() {
          scope.categoryIndex = 1;
          scope.films[0].year = 1980;
          return expect(scope.allFilms()).toEqual([]);
        });
        it("should filter Latest Releases to include films made this year", function() {
          scope.categoryIndex = 2;
          scope.films[0].year = new Date().getFullYear();
          return expect(scope.allFilms()).toEqual(scope.films);
        });
        it("should filter Latest Releases to include films made last year", function() {
          scope.categoryIndex = 2;
          scope.films[0].year = new Date().getFullYear() - 1;
          return expect(scope.allFilms()).toEqual(scope.films);
        });
        return it("should filter Latest Releases to exclude films made two years ago", function() {
          scope.categoryIndex = 2;
          scope.films[0].year = new Date().getFullYear() - 2;
          return expect(scope.allFilms()).toEqual([]);
        });
      });
    });
    return describe("Loading the films", function() {
      describe("which has not yet returned data from the server", function() {
        it("should provide a blank film title", function() {
          return expect(scope.short_title(scope.film)).toEqual("");
        });
        it("should provide an empty list of film dates", function() {
          return expect(scope.filmDates()).toEqual([]);
        });
        it("should identify this as not a great film", function() {
          return expect(scope.great(scope.film)).toBeFalsy();
        });
        return it("should identify this as not a superb film", function() {
          return expect(scope.superb(scope.film)).toBeFalsy();
        });
      });
      describe("which succeeds when retrieving from the server", function() {
        beforeEach(function() {
          httpBackend.expectGET("/films").respond(201, {
            films: [
              {
                title: 'a film (1939)',
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
        it("should identify if this is a great film", function() {
          this.film.rating = 90;
          return expect(scope.great(this.film)).toBeTruthy();
        });
        it("should identify if this is not a great film", function() {
          this.film.rating = 89;
          return expect(scope.great(this.film)).toBeFalsy();
        });
        it("should identify if this is a superb film", function() {
          this.film.rating = 95;
          return expect(scope.superb(this.film)).toBeTruthy();
        });
        it("should identify if this is not a superb film", function() {
          this.film.rating = 94;
          return expect(scope.superb(this.film)).toBeFalsy();
        });
        it("should provide all the films", function() {
          return expect(scope.films.length).toEqual(1);
        });
        it("should provide the film title", function() {
          return expect(this.film.title).toEqual("a film (1939)");
        });
        it("should provide the film title without the year", function() {
          return expect(scope.short_title(this.film)).toEqual("a film");
        });
        it("should provide the film date", function() {
          return expect(this.film.showings[0].day_on).toEqual("2001-12-26");
        });
        it("should provide a formatted date", function() {
          return expect(scope.when_formatted(this.film.showings[0].day_on)).toEqual("Wednesday 26 December");
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
                title: 'a film',
                rating: 42,
                showings: [
                  {
                    day_on: '2001-12-26'
                  }
                ]
              }, {
                title: 'another film',
                rating: 91,
                showings: [
                  {
                    day_on: '2001-12-25'
                  }
                ]
              }, {
                title: 'a third film',
                rating: 96,
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
        it("should provide a list of all films", function() {
          return expect(scope.allFilms()).toEqual(scope.films);
        });
        it("should provide a list of all great films", function() {
          scope.toggleRatingFilter();
          return expect(scope.allFilms()).toEqual([scope.films[1], scope.films[2]]);
        });
        it("should provide a list of all superb films", function() {
          scope.toggleRatingFilter();
          scope.toggleRatingFilter();
          return expect(scope.allFilms()).toEqual([scope.films[2]]);
        });
        it("should provide a list of dates for all films", function() {
          return expect(scope.filmsDates()).toEqual(["2001-12-25", "2001-12-26"]);
        });
        it("should provide a list of dates for all great films", function() {
          scope.toggleRatingFilter();
          return expect(scope.filmsDates()).toEqual(["2001-12-25", "2001-12-26"]);
        });
        it("should provide a list of dates for all superb films", function() {
          scope.toggleRatingFilter();
          scope.toggleRatingFilter();
          return expect(scope.filmsDates()).toEqual(["2001-12-26"]);
        });
        it("should toggle the filter", function() {
          scope.toggleRatingFilter();
          scope.toggleRatingFilter();
          scope.toggleRatingFilter();
          return expect(scope.allFilms()).toEqual(scope.films);
        });
        it("should provide a list of dates for a specific film", function() {
          scope.film = scope.films[0];
          return expect(scope.filmDates()).toEqual(["2001-12-26"]);
        });
        it("should get the films on a date", function() {
          expect(scope.filmsOn("2001-12-25")).toEqual([scope.films[1]]);
          return expect(scope.filmsOn("2001-12-26")).toEqual([scope.films[0], scope.films[2]]);
        });
        it("should get the great films on a date", function() {
          scope.toggleRatingFilter();
          expect(scope.filmsOn("2001-12-25")).toEqual([scope.films[1]]);
          return expect(scope.filmsOn("2001-12-26")).toEqual([scope.films[2]]);
        });
        return it("should get the great films on a date", function() {
          scope.toggleRatingFilter();
          scope.toggleRatingFilter();
          expect(scope.filmsOn("2001-12-25")).toEqual([]);
          return expect(scope.filmsOn("2001-12-26")).toEqual([scope.films[2]]);
        });
      });
      return describe("which retrieves a single film with multiple showings", function() {
        beforeEach(function() {
          httpBackend.expectGET("/films").respond(201, {
            films: [
              {
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
        it("should assign ids to the showings", function() {
          var showings;
          showings = scope.films[0].showings;
          expect(showings[0].id).toEqual(0);
          expect(showings[1].id).toEqual(1);
          return expect(showings[2].id).toEqual(2);
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
