"use strict";

var app;

console.log("Initializing Angular App");

app = angular.module("app", ["ngRoute"]);

app.config([
  "$routeProvider", function(routeProvider) {
    return routeProvider.when("/", {
      templateUrl: "views/films.html"
    });
  }
]);

