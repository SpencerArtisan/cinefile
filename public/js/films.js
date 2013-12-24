// Generated by CoffeeScript 1.3.3
(function() {
  'use strict';

  angular.module("app").controller("FilmsController", [
    "$scope", "$routeParams", "$resource", "$location", function(scope, routeParams, resource, location) {
      console.log("route params are " + routeParams.id);
      scope.mainStyle = {
        background: "red"
      };
      scope.loadFilms = function() {
        var success;
        success = function(response) {
          return scope.films = response.films;
        };
        return scope.loadFilmsFromBackend(success);
      };
      scope.loadFilm = function() {
        var success;
        success = function(response) {
          var background;
          scope.film = response.films[parseInt(routeParams.id) - 1];
          background = "<div class='main' style=\"background: url(\'" + scope.film.image + "\');background-size:320px 550px;background-repeat: no-repeat\"/>";
          console.log(background);
          return $('#template').append(background);
        };
        return scope.loadFilmsFromBackend(success);
      };
      scope.loadShowing = function() {
        var success;
        success = function(response) {
          scope.film = response.films[parseInt(routeParams.id) - 1];
          return scope.showing = scope.film.showings[parseInt(routeParams.showing_id)];
        };
        return scope.loadFilmsFromBackend(success);
      };
      scope.loadFilmsFromBackend = function(success) {
        var failure;
        failure = function(response) {
          return console.log("films failed with " + response.status);
        };
        return resource('/films', {}, {
          get: {
            method: 'GET',
            cache: true
          }
        }).get(success, failure);
      };
      scope.loadReview = function() {
        var failure, success;
        console.log("route params are " + routeParams.id);
        success = function(response) {
          var rottentomatoes;
          scope.film = response.films[parseInt(routeParams.id) - 1];
          rottentomatoes = "<object data='" + scope.film.link + "' type='text/html' style='margin-top:-155px' width='100%' height='3000px'>";
          return $('#content').append(rottentomatoes);
        };
        failure = function(response) {
          return console.log("films failed with " + response.status);
        };
        return resource('/films', {}, {
          get: {
            method: 'GET',
            cache: true
          }
        }).get(success, failure);
      };
      scope.loadCinema = function() {
        var success;
        success = function(response) {
          var map;
          scope.film = response.films[parseInt(routeParams.id) - 1];
          scope.showing = scope.film.showings[parseInt(routeParams.showing_id)];
          map = "<iframe width='320' height='500' frameborder='0' scrolling='no' marginheight='0' marginwidth='0' src='https://maps.google.co.uk/maps?q=" + scope.showing.cinema + "+cinema+london&amp;spn=0.028411,0.007193&amp;t=m&amp;output=embed'></iframe>";
          return $('#content').append(map);
        };
        return scope.loadFilmsFromBackend(success);
      };
      scope.filmDates = function() {
        var days_on, film, showing, showings;
        showings = (function() {
          var _i, _len, _ref, _results;
          _ref = scope.films;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            film = _ref[_i];
            _results.push(film.showings);
          }
          return _results;
        })();
        showings = _.flatten(showings);
        days_on = (function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = showings.length; _i < _len; _i++) {
            showing = showings[_i];
            _results.push(showing.day_on);
          }
          return _results;
        })();
        days_on = _.uniq(days_on);
        return _.sortBy(days_on, function(day) {
          return moment(day);
        });
      };
      scope.filmsOn = function(day) {
        var film, _i, _len, _ref, _results;
        console.log("FILMS ON");
        console.log(scope.films);
        _ref = scope.films;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          film = _ref[_i];
          if (scope.isOn(film, day)) {
            _results.push(film);
          }
        }
        return _results;
      };
      scope.isOn = function(film, day) {
        console.log("FILM IS ON");
        console.log(film);
        return _.some(film.showings, function(showing) {
          return showing.day_on === day;
        });
      };
      scope.when_formatted = function(day) {
        return moment(day).format('dddd D MMMM');
      };
      scope.short_title = function(film) {
        return film.title.split("(")[0];
      };
      scope.showFilm = function(id) {
        return location.path("/films/" + id);
      };
      return scope.link = function(film) {
        return encodeURIComponent(film.link);
      };
    }
  ]);

}).call(this);
