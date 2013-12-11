// Generated by CoffeeScript 1.3.3
(function() {
  'use strict';

  var controllers;

  console.log("Initializing Angular Controllers");

  controllers = angular.module("app");

  controllers.controller("FilmsController", [
    "$scope", "$resource", function(scope, resource) {
      scope.loadFilms = function() {
        var failure, success;
        scope.films = [];
        success = function(response) {
          console.log("films succeeded with " + response.films);
          return scope.films = response.films;
        };
        failure = function(response) {
          return console.log("films failed with " + response.status);
        };
        return resource('/films').get(success, failure);
      };
      return scope.when_formatted = function(showing) {
        return moment(showing.when).format('ddd Do MMM');
      };
    }
  ]);

}).call(this);
