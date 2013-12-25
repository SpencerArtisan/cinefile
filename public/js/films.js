// Generated by CoffeeScript 1.3.3
(function() {
  'use strict';

  angular.module("app").controller("FilmsController", [
    "$scope", "$routeParams", "$resource", "$location", function(scope, routeParams, resource, location) {
      scope.go = function(url) {
        return window.location = "#" + url;
      };
      scope.loadFilms = function() {
        return scope.loadFilmsFromBackend();
      };
      scope.loadFilm = function() {
        return scope.loadFilmsFromBackend(function() {
          var background;
          background = "<div class='main' style=\"background: url(\'" + scope.film.image + "\');background-size:320px 550px;background-repeat: no-repeat\"/>";
          return $('#template').append(background);
        });
      };
      scope.loadShowing = function() {
        return scope.loadFilmsFromBackend();
      };
      scope.loadCinema = function() {
        return scope.loadFilmsFromBackend(function() {
          var map;
          map = "<iframe width='320' height='500' frameborder='0' scrolling='no' marginheight='0' marginwidth='0' src='https://maps.google.co.uk/maps?q=" + scope.showing.cinema + "+cinema+london&amp;spn=0.028411,0.007193&amp;t=m&amp;output=embed'></iframe>";
          return $('#content').append(map);
        });
      };
      scope.loadFilmsFromBackend = function(extra_success) {
        var failure, success;
        if (extra_success == null) {
          extra_success = null;
        }
        success = function(response) {
          scope.films = response.films;
          if (routeParams.id) {
            scope.film = response.films[parseInt(routeParams.id) - 1];
          }
          if (routeParams.showing_id) {
            scope.showing = scope.film.showings[parseInt(routeParams.showing_id)];
          }
          _.each(scope.films, function(film) {
            return _.each(film.showings, function(showing, index) {
              return showing.id = index;
            });
          });
          if (extra_success) {
            return extra_success();
          }
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
      scope.filmsDates = function() {
        var film, showings;
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
        return scope.showingDates(_.flatten(showings));
      };
      scope.filmDates = function() {
        return scope.showingDates(scope.film.showings);
      };
      scope.showingDates = function(showings) {
        var days_on, showing;
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
      scope.showingsOn = function(day) {
        var showing, _i, _len, _ref, _results;
        _ref = scope.film.showings;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          showing = _ref[_i];
          if (showing.day_on === day) {
            _results.push(showing);
          }
        }
        return _results;
      };
      scope.filmsOn = function(day) {
        var film, _i, _len, _ref, _results;
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
