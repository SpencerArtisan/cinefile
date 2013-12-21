// Generated by CoffeeScript 1.3.3
(function() {
  "use strict";

  var app;

  console.log("Initializing Angular App");

  app = angular.module("app", ["ngRoute", "ngResource"]);

  app.config([
    "$routeProvider", function(routeProvider) {
      return routeProvider.when("/", {
        templateUrl: "views/films.html",
        controller: "FilmsController"
      }).when("/films/:id", {
        templateUrl: "views/film.html",
        controller: "FilmController"
      });
    }
  ]);

}).call(this);