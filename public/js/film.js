// Generated by CoffeeScript 1.3.3
(function() {
  'use strict';

  angular.module("app").controller("FilmController", [
    "$scope", "$routeParams", "$resource", "$location", function(scope, routeParams, resource, location) {
      scope.loadFilm = function() {
        var failure, success;
        success = function(response) {
          console.log("film succeeded with " + response.films);
          return scope.film = response;
        };
        failure = function(response) {
          return console.log("film failed with " + response.status);
        };
        return resource("/films/" + routeParams.id).get(success, failure);
      };
      scope.when_formatted = function(showing) {
        return moment(showing.day_on).format('ddd Do MMM');
      };
      scope.back = function(id) {
        return location.path("/");
      };
      return scope.init = function() {
        var rottentomatoes;
        scope.loadFilm();
        rottentomatoes = "<object data='" + scope.film.link + "' type='text/html' style='margin-top:-155px' width='100%' height='3000px'>";
        return $('#content').append(rottentomatoes);
      };
    }
  ]);

}).call(this);
